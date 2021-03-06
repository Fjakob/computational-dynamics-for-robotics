function out1 = MassMatrix(in1,in2)
%MASSMATRIX
%    OUT1 = MASSMATRIX(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    10-Jan-2021 03:33:22

% ✨ Automatically generated using EulerLagrange.m. ✨
I1zz = in2(:,1);
I2zz = in2(:,2);
I3zz = in2(:,3);
L1 = in2(:,4);
L2 = in2(:,5);
m1 = in2(:,7);
m2 = in2(:,8);
m3 = in2(:,9);
q2 = in1(2,:);
q3 = in1(3,:);
r1 = in2(:,10);
r2 = in2(:,11);
r3 = in2(:,12);
t2 = cos(q2);
t3 = cos(q3);
t4 = q2+q3;
t5 = L1.^2;
t6 = L2.^2;
t7 = r2.^2;
t8 = r3.^2;
t9 = cos(t4);
t10 = m3.*t6;
t11 = m2.*t7;
t12 = m3.*t8;
t13 = L1.*L2.*m3.*t2;
t14 = L1.*m2.*r2.*t2;
t15 = L2.*m3.*r3.*t3;
t16 = t15.*2.0;
t17 = L1.*m3.*r3.*t9;
t18 = I3zz+t12+t15;
t19 = t17+t18;
t20 = I2zz+I3zz+t10+t11+t12+t13+t14+t16+t17;
out1 = reshape([I1zz+t13+t14+t17+t20+m2.*t5+m3.*t5+m1.*r1.^2,t20,t19,t20,I2zz+I3zz+t10+t11+t12+t16,t18,t19,t18,I3zz+t12],[3,3]);
