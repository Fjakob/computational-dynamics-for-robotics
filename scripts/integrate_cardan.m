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
create alpha, alpha_dot, etc. as symbolic real variables

define R_sc in terms of angles (alpha, beta, gamma)
%    * hmmm, maybe there is a useful function we can use in
%      <matlab:open('Rot.m') Rot.m>

%% Compute $[\omega]$ in the Body Frame
% *before* writing any code, write down the time derivative of
% $R(\alpha(t), \beta(t), \gamma(t))$, $\dot{R}(\alpha(t), \beta(t),
% \gamma(t))$ using the chain rule.  Then apply the resulting equation in
% the for loop.  See <matlab:open('demo_compute_rdot.m')
% demo_compute_rdot.m> for an example.  The output of |omega_b| will be
% used as part of the next cell.

R_dot_sc = sym(zeros(3));  % allocate space for results
for r = 1:3 % row index
    for c = 1:3 % column index
        R_dot_sc(r, c) = d/dalpha(R_sc(r,c)) * d/dt(alpha) + ... ;
    end
end
R_dot_sc %#ok<NOPTS>

%%
% we symbolically compute $[\omega]$ in {c} and simplify the symbolic
% result. *Watch out!  There are two ways to define angular velocity.*  We
% are writing the angular velocity in the body frame {c}.

R_cs = the inverse of R_sc, since we're dealing with syms don't use '
omega_b_mat = the body angular velocity written in terms of R_dot and R;
omega_b_mat = simplify(expand(omega_b_mat));

omega_b = Rot.deskew(omega_b_mat) %#ok<NOPTS>


%% Compute B
% compute the linear mapping B which takes the Cardan angle velocities
% $(\dot{\alpha}, \dot{\beta}, \dot{\gamma})$ and maps them to $\omega_b$
%
% $$\omega_b = B * (\dot{alpha}, \dot{beta}, \dot{gamma})^T$$
%
% Then combine with |R_sc| to create |R_scB|.  We can extract $B$ from the
% the output of |omega_b| in the previous cell.

B = a matrix determined from the output of omega_b
R_scB = simplify(expand(R_sc * B));

%% From Symbolic Math to Numerical Expressions
% create numerical functions from the analytical
% expressions using <matlab:doc('matlabFunction') matlabFunction>.

R_sc_fct = matlabFunction(arguments to return R_sc as a function handle);
R_scB_fct = matlabFunction(arguments to return R_scB as a function handle);

%%
% define numerical values so that $R_{sc}(0) = Rot(\hat{z}_s,
% \frac{\pi}{2})$ and $\omega_s = \sqrt{\frac{1}{3}} (1, 1, 1)^T$.

alpha_num = ...
beta_num = ...
gamma_num = ...
R_sc_num = call to R_sc_fct

omega_s_num = ...

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
     R_scB_num = call to R_scB_fct
    
     cardan_velocities = solution to the following linear equation:
         R_scB_num * cardan_velocities = omega_s_num;
%       * do NOT call inv(); it's slow and considered bad practice.

    % Euler integration
    alpha_num = Euler integration using cardan_velocities;
    beta_num = Euler integration using cardan_velocities;
    gamma_num = Euler integration using cardan_velocities;

    % Compute new transformation from cardan angles:
    R_sc_num = R_sc_fct(alpha_num, beta_num, gamma_num);
    c.R = R_sc_num;
	drawnow();
    % add the frame so we can create an animation later
    snapshots = Utils.takesnapshot(env, snapshots);
end

% save a video
Utils.savesnapshots(snapshots, 'integrate_cardan.mp4');