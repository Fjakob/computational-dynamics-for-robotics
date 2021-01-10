function out1 = GravitationalForces(in1,in2)
%GRAVITATIONALFORCES
%    OUT1 = GRAVITATIONALFORCES(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    10-Jan-2021 03:33:22

% ✨ Automatically generated using EulerLagrange.m. ✨
L1 = in2(:,4);
L2 = in2(:,5);
g = in2(:,6);
m1 = in2(:,7);
m2 = in2(:,8);
m3 = in2(:,9);
q1 = in1(1,:);
q2 = in1(2,:);
q3 = in1(3,:);
r1 = in2(:,10);
r2 = in2(:,11);
r3 = in2(:,12);
t2 = cos(q1);
t3 = q1+q2;
t4 = cos(t3);
t5 = q3+t3;
t6 = cos(t5);
t7 = L2.*m3.*t4;
t8 = m2.*r2.*t4;
t9 = m3.*r3.*t6;
out1 = [g.*(t7+t8+t9+L1.*m2.*t2+L1.*m3.*t2+m1.*r1.*t2);g.*(t7+t8+t9);g.*t9];
