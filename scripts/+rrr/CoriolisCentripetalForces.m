function out1 = CoriolisCentripetalForces(in1,in2,in3)
%CORIOLISCENTRIPETALFORCES
%    OUT1 = CORIOLISCENTRIPETALFORCES(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    10-Jan-2021 03:33:23

% ✨ Automatically generated using EulerLagrange.m. ✨
L1 = in3(:,4);
L2 = in3(:,5);
m2 = in3(:,8);
m3 = in3(:,9);
q2 = in1(2,:);
q3 = in1(3,:);
q1dot = in2(1,:);
q2dot = in2(2,:);
q3dot = in2(3,:);
r2 = in3(:,11);
r3 = in3(:,12);
t2 = sin(q2);
t3 = sin(q3);
t4 = q2+q3;
t5 = q1dot.^2;
t6 = q2dot.^2;
t7 = q3dot.^2;
t8 = sin(t4);
t9 = L1.*L2.*m3.*t2;
t10 = L1.*m2.*r2.*t2;
t11 = L2.*m3.*r3.*t3;
t12 = L1.*m3.*r3.*t8;
t13 = t11+t12;
t14 = t9+t10+t12;
out1 = [-t6.*t14-t7.*t13-q1dot.*q2dot.*t14.*2.0-q1dot.*q3dot.*t13.*2.0-q2dot.*q3dot.*t13.*2.0;-t7.*t11+t5.*t14-q1dot.*q3dot.*t11.*2.0-q2dot.*q3dot.*t11.*2.0;t6.*t11+t5.*t13+q1dot.*q2dot.*t11.*2.0];
