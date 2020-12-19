function polymorphism_at_work_sub(dispASubClass)
if isa(dispASubClass, 'DispASubClass')
    disp('OK!  Will call dispC()')
    dispASubClass.dispC();
else
    disp('This is NOT an instance of DispASubClass!')
end
end