function polymorphism_at_work_super(dispAClass)
if isa(dispAClass, 'DispABaseClass')
    disp('OK!  Will call dispA(7)')
    dispAClass.dispA(7);
else
    disp('This is NOT an instance of DispABaseClass!')
end
end