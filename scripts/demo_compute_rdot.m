% DEMO_COMPUTE_RDOT A demo on computing derivatives of rotation matrices.
%   This script shows how to use the Symbolic Math Toolbox for computing
%   the derivative of a rotation matrix.
%
%   See also DEMO_SINGLE_ROTATION and DEMO_DOUBLE_ROTATION.

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/16/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

%% Set the Matlab Path
% Run |cdr_addpath.m| in the LectureCDR root directory to set the path. You
% can find out more about setting the path in
% <matlab:open('demo_single_rotation.m') demo_single_rotation.m>.

%% Defining Symbolic Variables
% You have two options for declaring symbolic variables in Matlab
%
% * |gamma = sym('gamma','real');|
% * |syms gamma real;|
%
% We can then use a symbolic variable to define other symbolic variables.
% Here we define a symbolic rotation matrix |R_sb| and it's inverse (note
% the use of the transpose!).

clear;
syms gamma real;

R_sb = Rot.z(gamma) %#ok<NOPTS> <- tell Matlab not to display a warning
R_bs = R_sb' %#ok<NOPTS>

%% The Chain Rule
% We could define |gamma| as |gamma(t)| and then have Matlab symbolically
% compute the time derivatives of |R_sb| for us (see next section).
% Instead, we will compute derivatives using the chain rule, which we can
% use to compute the derivative of numeric and symbolic data types.  Given
% that |R_sb| is only a function of |gamma| and that $\frac{d \gamma}{dt}$
% is |gamma_dot| (which we assume to know the value of), we apply the chain
% rule for differentiation.  That is given $f(x(t))$,
%
% $$\frac{df(x(t))}{dt} = \frac{\partial f}{\partial x}(x(t))
% \frac{dx}{dt}(t) = \frac{\partial f}{\partial x}(x(t)) \dot{x}(t).$$
%
% For $R_{sb}$, this means $\dot{R}_{sb} = \frac{\partial R_{sb}}{\partial
% \gamma} \dot{\gamma}$.  Given that we compute the derivative elementwise
% in $R_{sb}$, we use nested loops and the built-in function
% <matlab:doc('symbolic/diff') diff> to compute $\dot{R}_{sb}$.

syms gamma_dot real;

R_dot_sb = sym(zeros(3));  % allocate space for results using symbolic 0
for i = 1:3 % Columns
    for j = 1:3 % Rows
        % Compute partial derivative using the 'diff'-command. Then
        % multiply result by 'gamma_dot':
        R_dot_sb(i,j) = diff(R_sb(i,j), gamma) * gamma_dot;
    end
end

R_dot_sb %#ok<NOPTS>

%% Computing the Angular Velocity in the Body Frame {b}
% Now that we have $R_{sb}^{-1}$ and $\dot{R}_{sb}$, we can compute the
% angular velocity $[\omega_b] = R_{sb}^{-1}\dot{R}_{sb}$ in the body frame
% {b}.  Because the results are symbolic, we also
% <matlab:doc('symbolic/simplify') simplify> the result.  You should
% generally try to simplify  if it doesn't take too long to execute.

omega_b = R_bs * R_dot_sb  %#ok<NOPTS>
omega_b = simplify(expand(omega_b)) %#ok<NOPTS>

%% Explicitly Differentiating with Respect to Time
% We again compute R_dot_sb, but explicitly with respect to $t$.  The
% development here largely parallels the previous section, but instead of a
% double for loop we let Matlab's <matlab:doc('symbolic/diff') diff>
% function compute the derivative. Here is some numbered commentary:
%
% # Note how |gamma2| is an explicit function of time, while |gamma| was
% not.
% # This in turn makes |R_sb2| an explicit function of time
% # We still create the inverse by transposing, but *do not* use R_sb',
% since you would get the conjugated transpose.  Use the nonconjugate
% <matlab:doc('transpose') transpose>.
% # Compute the derivative |R_dot_sb2|
% # Compute the angular velocity |omega_b2|, and
% # Symbolically simplify the result.
%
% After running this cell, what we'll see is that the results are not as
% pretty since we can't tell Matlab that D(gamma)(t) = gamma_dot.  We
% recommend the chain rule approach, which also explicitly shows you that
% velocities are linear functions.

syms t real;
syms gamma2(t); % (1)

R_sb2 = Rot.z(gamma2) %#ok<NOPTS> (2)
R_bs2 = transpose(R_sb2); % (3)
R_dot_sb2 = diff(R_sb2, t)  %#ok<NOPTS> (4)
omega_b2 = R_bs2 * R_dot_sb2; % (5)
omega_b2 = simplify(expand(omega_b2))  %#ok<NOPTS> (6)

%% From Symbolic Math to Numerical Expressions
% In this example, we'll create numerical functions from the analytical
% ones with the help of <matlab:doc('matlabFunction') matlabFunction>. Here
% we'll return the result as a function handle, but we could also save it
% to a '.m' file by passing the (key, value) pair |('File', 'FileName.m')|;
% that is |matlabFunction(R_sb,'File', 'R_sb_fct.m', 'Vars', gamma)|.

R_sb_fct = matlabFunction(R_sb, 'Vars', gamma);
omega_b_fct = matlabFunction(omega_b, 'Vars', [gamma, gamma_dot]);

%%
% Now define numerical values for |gamma| and generate numerical
% representation of |R_sb| and |omega_b|.

gamma_num = 30 * pi / 180;
gamma_dot_num = 1;

R_sb_num = R_sb_fct(gamma_num);
omega_b_num = omega_b_fct(gamma_num, gamma_dot_num);

%%
% Finally, create a physical (graphical) environment, the frame {c}, and
% the vectors u_c and u_dot_c and start to visualize our results.

env = Environment();
env.show();

c = Frame(env, R_sb_num);
c.color = Utils.RED;
c.name = 'C';

u_c = [0.5;0.5;0.0];
u = CoordVector(env, c, u_c);
u.color = Utils.BLACK;

u_dot_c = omega_b_num * u_c;
u_dot = CoordVector(env, c, u_dot_c);
u_dot.color = Utils.GRAY;

%% Animate the Plot
% We'll animate the frame for different values of gamma $(t \in [0, \pi])$
% over |n| steps using Euler integration.

n = 200;
delta_t = 2*pi/n;
gamma_num     = 30*pi/180;
gamma_dot_num = 1;
snapshots = Utils.takesnapshot(env); % save the current figure
for i = 1:n
    % Euler forward integration:
    gamma_num = gamma_num + gamma_dot_num * delta_t;
    % Set this value to the rotated frame:
    c.R = R_sb_fct(gamma_num);
    % Update the vector:
    u.setCoords(c, u_c);
    
    % And its derivative
    u_dot_c = omega_b_fct(gamma_num, gamma_dot_num) * u_c;
    u_dot.setCoords(c, u_dot_c);
    
    drawnow();
    snapshots = Utils.takesnapshot(env, snapshots); % append another figure
end

% save a video (examine the code in Utils to see other output options)
Utils.savesnapshots(snapshots, 'demo_compute_rdot.mp4');