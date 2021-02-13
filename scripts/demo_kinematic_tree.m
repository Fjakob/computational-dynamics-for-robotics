% DEMO_KINEMATIC_TREE Compares run time of the CRB and RNEA
%   This demo compares the runtime of the CRBA and RNEA in computing the
%   mass matrix M(q).
%
%   Note:
%       To view a specific topology, do
%           root = Utils.kinematicTree(d, k);
%           html = fullfile(tempdir, 'main.html');
%           tree(root, html);
%           open(html);
%
%   See also UTILS/KINEMATICTREE

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 02/12/2021, Matlab R2020a, v1


%% Branching Factor and Tree Depth
%   K is the set of children we iterate over for tree depth = 1.
%   D is the set of depths we iterate over with fixed children at each
%   depth.

K = 1:25;
D = 2:50;

%% Show Sample Topologies
%   We look at three example topologies: hand-like, arm-like, and
%   humanoid-like kinematic trees

%%
%   hand-like

root = Utils.kinematicTree(1, 5);
html = fullfile(tempdir, 'hand-example.html');
tree(root, html);
open(html);

%%
%   arm-like

root = Utils.kinematicTree(4, 1);
html = fullfile(tempdir, 'arm-example.html');
tree(root, html);
open(html);

%%
%   humanoid-like

root = Utils.kinematicTree(5, [1 4 1 1 1]);
html = fullfile(tempdir, 'humanoid-example.html');
tree(root, html);
open(html);

%% Robot Hand-Like Topology
%   Compute run time for k independent bodies

%%
% RNEA hand-like topology

rnea_hand = [];

fprintf('computing RNEA with robot hand-like topology...\n');
tic;
for i = K
    [root, n] = Utils.kinematicTree(1, i);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = RecursiveNewtonEuler(root);
    rnea_hand(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);

%%
% CRB hand-like topology

crb_hand = [];

fprintf('computing CRB with robot hand-like topology...\n');
tic;
for i = K
    [root, n] = Utils.kinematicTree(1, i);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = CompositeRigidBody(root);
    crb_hand(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);

%% Robot Arm-Like Topology
%   Compute run time for serial (unbranched) kinematic tree

%%
% RNEA arm-like topology

rnea_arm = [];

fprintf('computing RNEA with robot arm-like topology...\n');
tic;
for i = D
    k = ones(1, i);
    [root, n] = Utils.kinematicTree(i, k);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = RecursiveNewtonEuler(root);
    rnea_arm(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);

%%
% CRB arm-like topology

crb_arm = [];

fprintf('computing CRB with robot arm-like topology...\n');
tic;
for i = D
    k = ones(1, i);
    [root, n] = Utils.kinematicTree(i, k);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = CompositeRigidBody(root);
    crb_arm(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);

%% Robot Humanoid-Like Topology
%   Compute run time for serial (unbranched) kinematic tree

%%
% RNEA humanoid-like topology

rnea_human = [];

fprintf('computing RNEA with robot humanoid-like topology...\n');
tic;
for i = D
    k = [1, 4, ones(1, i - 2)];
    [root, n] = Utils.kinematicTree(i, k);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = RecursiveNewtonEuler(root);
    rnea_human(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);

%%
% CRB humanoid-like topology

crb_human = [];

fprintf('computing CRB with robot humanoid-like topology...\n');
tic;
for i = D
    k = [1, 4, ones(1, i - 2)];
    [root, n] = Utils.kinematicTree(i, k);
    q = zeros(n, 1);
    
    root.storeDefault();
    robot = CompositeRigidBody(root);
    crb_human(end + 1) = timeit(@() robot.M(q)); %#ok<SAGROW>
end
fprintf('...done; %f seconds to run.\n', toc);


%% Plot Results

subplot(3, 3, 1)
f = fit(K', rnea_hand', 'poly2');
plot(f, K, rnea_hand, '-x');
title('RNEA Run Time of Hand-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 2)
f = fit(K', crb_hand', 'poly2');
plot(f, K, crb_hand, '-x');
title('CRB Run Time of Hand-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 3)
ratio = rnea_hand ./ crb_hand;
stem(K, ratio, '-x');
title('RNEA / CRB Run Time of Hand-Like Topology');
xlabel('# of Nodes');
ylabel('RNEA Time / CRB Time')

subplot(3, 3, 4)
f = fit(D', rnea_arm', 'poly2');
plot(f, D, rnea_arm, '-x');
title('RNEA Run Time of Arm-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 5)
f = fit(D', crb_arm', 'poly2');
plot(f, D, crb_arm, '-x');
title('CRB Run Time of Arm-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 6)
ratio = rnea_arm ./ crb_arm;
stem(D, ratio, '-x');
title('RNEA / CRB Run Time of Arm-Like Topology');
xlabel('# of Nodes');
ylabel('RNEA Time / CRB Time')

subplot(3, 3, 7)
N = 5 + 4 * (D - 2);
f = fit(N', rnea_human', 'poly2');
plot(f, N, rnea_human, '-x');
title('RNEA Run Time of Humanoid-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 8)
f = fit(N', crb_human', 'poly2');
plot(f, N, crb_human, '-x');
title('CRB Run Time of Humanoid-Like Topology');
xlabel('# of Nodes');
ylabel('time (seconds)')
legend('Location','northwest');

subplot(3, 3, 9)
ratio = rnea_human ./ crb_human;
stem(N, ratio, '-x');
xlabel('# of Nodes');
ylabel('RNEA Time / CRB Time')