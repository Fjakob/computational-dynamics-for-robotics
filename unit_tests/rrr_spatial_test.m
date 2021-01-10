% RRR_SPATIAL_TEST Tests the KE and PE equations.
%   Note:
%       Because of the call to clear in the script, it is not
%       straightforward to use a class-based unit test.
%
%   Example:
%       runtests('rrr_spatial_test');
%
%   See also RRR_DYNAMICS_SPATIAL and RRR_TRADITIONAL_TEST

run rrr_dynamics_spatial;

e = load('rrr_pe_ke.mat');
z = sym(0);

assert(isequal(simplify(e.ke - ke), z), ...
    'Expected and actual kinetic energies do not match.');

assert(isequal(simplify(e.pe - pe), z), ...
    'Expected and actual potential energies do not match.');