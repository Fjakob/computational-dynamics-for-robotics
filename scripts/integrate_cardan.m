% INTEGRATE_CARDAN A script for animating a frame by integrating the
% time rate of change of the Cardan angles $(\alpha, \beta, \gamma)$.
%
%   See also DEMO_COMPUTE_RDOT and CARDAN_ROTATIONS.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/20/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

%% Create Symbolic Cardan Angles
% Declare the Cardan angles $(\alpha, \gamma, \beta)$ and their time
% derivatives $(\dot{\alpha}, \dot{\beta}, \dot{\gamma})$ as real symbolic
% variables.  Then use these variables to define |R_sc|.  See
% <matlab:open('demo_compute_rdot.m') demo_compute_rdot.m> for simple
% examples of using the Symbolic Math Toolbox.

clear;
syms alpha alpha_dot beta beta_dot gamma gamma_dot real
R_sc = Rot.cardan(alpha, beta, gamma) %#ok<NOPTS>

%% Compute $[\omega]$ in the Body Frame
% *before* writing any code, write down the time derivative of
% $R(\alpha(t), \beta(t), \gamma(t))$---that is $\dot{R}(\alpha(t),
% \beta(t), \gamma(t))$, using the chain rule for an element of $R(t)$.  In
% other words, if $r_{ij}(t)$ is the value at the $i^\text{th}$ row in the
% $j^\text{th}$ column of $R(t)$, what is $\frac{d r_{ij}(t)}{dt}$?  Then
% apply the resulting equation in the for loop.  See
% <matlab:open('demo_compute_rdot.m') demo_compute_rdot.m> for an example.

R_dot_sc = sym(zeros(3));  % allocate space for results
for r = 1:3 % row index
    for c = 1:3 % column index
        R_dot_sc(r, c) = diff(R_sc(r, c), alpha) * alpha_dot ...
            + diff(R_sc(r, c), beta) * beta_dot ...
            + diff(R_sc(r, c), gamma) * gamma_dot;
    end
end
R_dot_sc %#ok<NOPTS>

%%
% we symbolically compute $[\omega]$ in {c} and simplify the symbolic
% result. *Watch out!  There are two ways to define angular velocity.*  We
% are writing the angular velocity in the body frame {c}.  The output of
% |omega_c| will be used as part of the next cell.

R_cs = transpose(R_sc);
omega_c_mat = R_cs*R_dot_sc;
omega_c_mat = simplify(expand(omega_c_mat)) %#ok<NOPTS>

% convert from the matrix representation of \omega back to its vector form
omega_c = Rot.deskew(omega_c_mat) %#ok<NOPTS>

%% Compute B
% compute the linear mapping B which takes the Cardan angle velocities
% $(\dot{\alpha}, \dot{\beta}, \dot{\gamma})$ and maps them to $\omega_c$
%
% $$\omega_c = B \left[ \begin{array}{c} \dot{\alpha} \\ \dot{\beta} \\
% \dot{\gamma} \end{array} \right]$$
%
% Then combine with |R_sc| to create |R_scB|.  We can extract $B$ from the
% the output of |omega_c| in the previous cell.

<<<<<<< HEAD
B = [1, 0, -sin(beta);
    0, cos(alpha), sin(alpha)*cos(beta);
    0, -sin(alpha), cos(alpha)*cos(beta)] %#ok<NOPTS>

% alternatively
% B = jacobian(omega_c, [alpha_dot, beta_dot, gamma_dot])
=======
% B = [1, 0, -sin(beta);
%     0, cos(alpha), sin(alpha)*cos(beta);
%     0, -sin(alpha), cos(alpha)*cos(beta)];
>>>>>>> parent of 4143c7e (creating a new template version of Ex2)

B = jacobian(omega_c, [alpha_dot, beta_dot, gamma_dot]) %#ok<NOPTS>
R_scB = simplify(expand(R_sc * B));

%% From Symbolic Math to Numerical Expressions
% create numerical functions from the analytical
% expressions using <matlab:doc('matlabFunction') matlabFunction>.

R_sc_fct = matlabFunction(R_sc, 'Vars', [alpha, beta, gamma]);
R_scB_fct = matlabFunction(R_scB, 'Vars', [alpha, beta, gamma]);

%%
% define numerical values so that $R_{sc}(0) = Rot(\hat{z}_s,
% \frac{\pi}{2})$ and $\omega_s = \sqrt{\frac{1}{3}} (1, 1, 1)^T$.

alpha_num = 0;
beta_num = 0;
gamma_num = pi / 2;
R_sc_num = R_sc_fct(alpha_num, beta_num, gamma_num);

omega_s_num = sqrt(1/3) * [1; 1; 1];

%% Create the Environment
% create a physical (graphical) environment, which shows the fixed frame,
% moving frame, and the axis of rotation in {s}.
env = Environment();
env.show();

c = Frame(env, R_sc_num);
c.color = Utils.MAGENTA;
c.name = 'c';

v_omega = CoordVector(env, c, omega_s_num);
v_omega.color = Utils.YELLOW;
v_omega.name = '$v_\omega$';

%% Animate the Frame
%
n = 100;
delta_t = 2 * pi/n;
snapshots = Utils.takesnapshot(env); % save the current figure
for i = 1:n
    % compute cardan angle velocities; never call inverse, use linear solve
    R_scB_num = R_scB_fct(alpha_num, beta_num, gamma_num);
    cardan_velocities = R_scB_num \ omega_s_num;
    
    % Euler integration
    alpha_num = alpha_num + cardan_velocities(1) * delta_t;
    beta_num  = beta_num  + cardan_velocities(2) * delta_t;
    gamma_num = gamma_num + cardan_velocities(3) * delta_t;
        
    % Compute new transformation from cardan angles:
    R_sc_num = R_sc_fct(alpha_num, beta_num, gamma_num);
    c.R = R_sc_num;
	drawnow();
    % add the frame so we can create an animation later
    snapshots = Utils.takesnapshot(env, snapshots);
end

% save a video
Utils.savesnapshots(snapshots, 'integrate_cardan.mp4');