classdef EulerLagrange < handle
    % EulerLagrange Computes the dynamics using Euler-Lagrange equations
    %   The dynamics of the multibody system is computed using the
    %   Euler-Lagrange equations for mechanical systems using various
    %   tricks to avoid taking time derivatives (the chain rule in
    %   disguise).
    %
    %   EulerLagrange Properties:
    %       KE - The kinetic energy of the mechanical system
    %       PE - The potential energy of the mechanical system
    %       GeneralizedCoordinates - The generalized coordinates
    %       GeneralizedVelocities - The generalized velocities
    %       MassMatrix - The nxn symmetric, positive definite mass matrix
    %       GravitationalForces - A vector of conservative forces
    %       CoriolisCentripetalForces - A vector of forces quadratic in vel
    %
    %   EulerLagrange Methods:
    %      EulerLagrange - The constructor for this class
    %      computeDynamics - Computes the dynamics of a mechanical system
    %      subs - Replaces variables of one type with another
    %      writeToFile - Saves the symbolic variables to a  file
    
    % AUTHORS:
    %   <------------ Add your info! ------------>    
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/15/2020, Matlab R2020a, v1    
    
    properties (the attribute setting that makes these variables read only)
%       * we want users of our library to get a value, but not set it.
        KE % The total kinetic energy of an n-dof system
        PE % The total potential energy of an n-dof system
        GeneralizedCoordinates % The user-defined generalized coordinates
        GeneralizedVelocities % The user-defined generalized velocities
        MassMatrix % The nxn symmetric, positive definite mass matrix
        GravitationalForces % The nx1 vector of conservative forces
        CoriolisCentripetalForces % The nx1 vector of quadratic vel. forces
    end
    properties (Constant)
        PROPS = {'MassMatrix', 'GravitationalForces', ...
                'CoriolisCentripetalForces', 'KE', 'PE'};
    end
    properties (Dependent)
        Parameters % The set of model parameters
    end
    methods
        %% Constructor        
        function obj = EulerLagrange(ke, pe, q, qdot)
            % EulerLagrange Computes the equations of motion
            %   OBJ = EulerLagrange(KE, PE, Q, QDOT) Symbolically computes
            %   a standard form of the equations of motion using the
            %   robot's kinetic energy KE, potential energy PE, and vectors
            %   of symbolic generalized coordinates and velocities of
            %   length |n| each.
            
            assign the inputs ke, pe, q, and qdot to their corresponding 
            properties
%               * given obj, you set properties as obj.Property = value
%               * while you can give properties initial values in the
%                 properties block, in general, initializiation happens in
%                 the constructor.
            % we'll set the remaining properties inside their respective
            % methods; note how we don't have to explicitly initialize all
            % properties in the constructor; we can have the rest of the
            % initialization occur in other functions (as long as we call
            % them in the constructor).
            obj.computeDynamics();
        end
        %% Property Setter/Getter Methods        
        function params = get.Parameters(obj)
            % get.Parameters Get a list of parameters
            %   get.Parameters(OBJ) Returns a sorted list of parameters,
            %   which are defined as all symbolic variables that are not
            %   generalized coordinates or velocities.
            
            q = obj.GeneralizedCoordinates;
            qdot = obj.GeneralizedVelocities;
            % properties of interest
            props = EulerLagrange.PROPS;
            % use cellfun to apply f to props
            f = @(p) symvar(obj.(p));
            params = cellfun(f, props, 'UniformOutput', false);
            % convert cell array to regular array
            params = [params{:}];
            % remove q and qdot from list
            params = setdiff(params, [q; qdot]);
        end
        %% Public Methods        
        function computeDynamics(obj)
            % computeDynamics Sets the property values
            %   computeDynamics(OBJ) Sets the values of obj.MassMatrix,
            %   obj.GravitationalForces, and obj.CoriolisCentripetalForces
            %   given the kinetic energy, potential energy, generalized
            %   coordinates, and generalized velocities of the system.
            
            obj.computeGravitationalForces();
            obj.computeMassMatrix();
            obj.computeCoriolisCentripetalForces();
        end
        function subs(obj, old, new)
            % subs Substitute model state and parameter values
            %   subs(OBJ, OLD, NEW) Replaces every instance of OLD in the
            %   Euler-Lagrange equations with instances of NEW.
            %
            %   See also sym/subs.
            
            props =  EulerLagrange.PROPS;
            for i = 1:length(props)
                p = props{i};
                obj.(p) = subs(obj.(p), old, new);
            end
        end
        function dir = writeToFile(obj, name, varargin)
            % writeToFile Writes properties to file.
            %   writeToFile(OBJ, NAME, OPTS) Saves the various properties
            %   as Matlab functions to disk in the package directory
            %   specified by NAME.  OPTS are a set of valid options for the
            %   built-in Matlab function matlabFunction(...).
            %
            %   Note:
            %       NAME can be any valid file system path; the last folder
            %       is considered the package folder and a '+' is added if
            %       needed to convert the last folder into a Matlab
            %       package.
            
            dir = parsepath(name);
            if exist(dir, 'dir') == 7
                status = true;
            else
                status = mkdir(dir);
            end
            if status
                q = obj.GeneralizedCoordinates;
                qdot = obj.GeneralizedVelocities;
                p = obj.Parameters;
                c = getcomment();
                props =  EulerLagrange.PROPS;
                for i = 1:length(props)
                    a = props{i};
                    s = symvar(obj.(a));
                    vars = [];
                    if any(ismember(p, s))
                        vars = [{p} vars]; %#ok<AGROW>
                    end
                    if any(ismember(qdot, s))
                        vars = [{qdot} vars]; %#ok<AGROW>
                    end
                    if any(ismember(q, s))
                        vars = [{q} vars]; %#ok<AGROW>
                    end
                    % for repeated options, last option takes precedence
                    matlabFunction(obj.(a), 'File', [dir, a], ...
                        'Comments', c, 'Vars', vars, ...
                        varargin{:});
                end
                obj.writeFowardDynamicsToFile(name);
            end
        end
    end
    methods (Access = private)
        %% Private Methods
        function computeGravitationalForces(obj)
            % computeGravitationalForces Computes the vector of potential
            % forces
            %   computeGravitationalForces(OBJ) Sets
            %   OBJ.GravitationalForces to the gravitational force vector
            %   g(q) \in R^n of the rigid body system. The gravitational
            %   force vector is computed from the potential energy OBJ.PE
            %   of the system, where
            %
            %   $$g(q) = \frac{\partial PE(q)}{\partial q}$$
            
            % if you access a property several times (or want to rename the
            % property to something more convenient), you should place the
            % value in a local variable.  In this case, the property name
            % is too long, so we give it a shorter alias in this function.
            q = obj.GeneralizedCoordinates;
%               + you should add more code as needed.
            obj.GravitationalForces = some function of obj.PE and q;
%               * to compute obj.GravitationalForces, you can either
%                   1) create a local variable g (and any other variables 
%                      you might need) and write a for loop to compute 
%                      $g(i) = \frac{\partial PE(q)}{\partial q_i}$ and 
%                      assign g to obj.GravitationalForces, or
%                   2) use the Matlab |jacobian| function with obj.PE and
%                      q.  Beware!  |jacobian| returns a row vector, we
%                      want a column vector.  Beware!!!!  We are working
%                      with symbolic variables, so you should use the
%                      syms-friendly transpose() function (or .' for short)
        end        
        function computeMassMatrix(obj)
            % computeMassMatrix Computes the mass matrix
            %   computeMassMatrix(OBJ) Sets OBJ.MassMatrix to the masss
            %   matrix  M(q) \in R^(n x n) (M(q) > 0 and M(q) = M(q)^T) of
            %   the rigid body system.  The mass matrix is computed from
            %   the kinetic energy OBJ.KE of the system, where
            %
            %   $$M(i, j) = \frac{\partial^2 KE(q, \dot{q})}{\partial
            %   \dot{q}_i \partial \dot{q}_j}$$
            
            % if you access a property several times (or want to rename the
            % property to something more convenient), you should place the
            % value in a local variable.  You can access values more
            % quickly when stored in a local variable, make your code
            % easier to maintain, and more readable to others (including
            % your future self).
            ke = obj.KE;
            obj.MassMatrix = ???
%               + to compute obj.MassMatrix, either
%                   1) write a double for loop to compute M(i, j) and 
%                      assign M to obj.MassMatrix, or
%                   2) use the Matlab |jacobian| function (you won't need
%                      to code as much with this approach)            
%               + what are some other local variables that would be useful
%                 to define?  Consider defining local variables for n (the
%                 degrees of freedom of the robot), qdot (a vector of 
%                 length n), and M.  We can assign our local copy of M to 
%                 obj.MassMatrix as our last step: obj.MassMatrix = M.
        end
        function Gijk = christoffelSymbols(obj, i, j, k)
            % christoffelSymbols Computes the entries of a tensor
            %   christoffelSymbols(OBJ, I, J, K) Returns the (i, j, k)
            %   Christoffel symbols of the first kind of M.  These entries
            %   can be used to compute $\dot{M} = \frac{\partial
            %   M(q)}{\partial q} \dot{q}$  such that
            %
            %   $$\frac{\partial M(q)}{\partial q}(i, j, k) = \Gamma_{ijk}
            %   = \frac{1}{2} \frac{\partial M(i, j)}{\partial q(k)}
            %   + \frac{1}{2} \frac{\partial M(i, k)}{\partial q(j)}
            %   - \frac{1}{2} \frac{\partial M(j, k)}{\partial q(i)}$$
            %
            %   Note:
            %       This is a helper function for
            %       computeCoriolisCentripetalForces
            
            q = obj.GeneralizedCoordinates;
            M = obj.MassMatrix;
            dMijdqk = M(i, j) differentiated with respect to q(k)
            dMikdqj = ... and so on
            dMjkdqi = ... and so forth
            Gijk = \Gamma_{ijk}
        end        
        function computeCoriolisCentripetalForces(obj)
            % computeCoriolisCentripetalForces Computes the force vector of
            % velocity dependent forces.
            %   computeCoriolisCentripetalForces(OBJ) Sets
            %   OBJ.CoriolisCentripetalForces to the n x 1 vector of
            %   Coriolis and centripetal forces acting on the rigid body
            %   system.  These forces are quadratic in the velocities where
            %   $\dot{q}_i^2$ in the vector are centripetal terms and
            %   $\dot{q}_i \dot{q}_j$ are Coriolis terms (1 <= i,j <= n).
            %   The Coriolis and centripetal force vector c \in R^n is
            %   computed from the mass matrix M of the system, where
            %
            %   $$c(i) = \sum\limits_{j = 1}^n \sum\limits_{k = 1}^n
            %   \Gamma_{ijk} \dot{q}_j \dot{q}_k,$$
            %
            %   where $\Gamma_{ijk}$ is a function of M.
            %
            %   See also christoffelSymbols.
            
            qdot = obj.GeneralizedVelocities;
            n = length(qdot);
            c = sym(zeros(n,1));
%               + write a triple loop to compute 
%                 c(i) = \Gamma(i, j, k) * qdot(j) * qdot(k);
            obj.CoriolisCentripetalForces = c;
        end
        function dir = writeFowardDynamicsToFile(obj, name)
            % writeFowardDynamicsToFile Write the forward dynamics.
            %   writeFowardDynamicsToFile(OBJ, NAME) Saves a Matlab
            %   function file to disk in the package directory specified by
            %   NAME.  The function prototype is
            %
            %       qddot = ForwardDynamics(q, qdot, tau, params),
            %
            %   where qddot is a vector of accelerations, q are the
            %   generalized coordinates, qdot are the generalized
            %   velocities, tau are the generalized forces, and params is a
            %   vector of parameters.  The order of the parameters can be
            %   determined from the property OBJ.Parameters.
            %
            %   Note:
            %       NAME can be any valid file system path; the last folder
            %       is considered the package folder and a '+' is added if
            %       needed to convert the last folder into a Matlab
            %       package.
            %
            %   See also EulerLagrange.Parameters and
            %   EulerLagrange.writeToFile
            
            [dir, packname] = parsepath(name);
            if isempty(obj.Parameters)
                params = '';
            else
                params = ', params';
            end
            filename = fullfile(dir, 'ForwardDynamics.m');
            
            f = fopen(filename, 'w');
            if f ~= -1
                func = {
                    ['function qdd = ' ...
                    'ForwardDynamics(q, qdot, tau, params) %#ok<INUSD>'];
                    '% FORWARDDYNAMICS Computes acceleration';
                    ['% ', ...
                    sprintf(...
                    '\tQDDOT = FORWARDDYNAMICS(Q, QDOT, TAU%s)', ...
                    upper(params))];
                    '';
                    ['%', getcomment()];
                    sprintf('M = %s.MassMatrix(q%s);', packname, params);
                    sprintf(['c = %s.CoriolisCentripetalForces', ...
                    '(q, qdot%s);'], packname, params);
                    sprintf('g = %s.GravitationalForces(q%s);', ...
                    packname, params);
                    'qdd = M \ (tau - c - g);';
                    'end'
                    };
                fprintf(f, '%s\n', func{:});
                fclose(f);
            end
        end
    end
end

%% Private Functions
function c = getcomment()
c = ' ✨ Automatically generated using EulerLagrange.m. ✨';
end

function [f, packageName] = parsepath(name)
% convert to OS specific filesep and then split string
f = fullfile(name);
f = strsplit(f, filesep);
if isempty(f{end})
    % we have a trailing '/' at the end (e.g., my/path/to/name/); ignore it
    f = f(1:end - 1);
end
% last element is package name; add '+' if necessary
if f{end}(1) ~= '+'
    name = f{end};
    f{end} = ['+', f{end}];
else
    name = f{end}(2:end);
end
% put path together
f = strcat(f, {filesep});
f = fullfile(f{:});

if nargout > 1
    packageName = name;
end
end