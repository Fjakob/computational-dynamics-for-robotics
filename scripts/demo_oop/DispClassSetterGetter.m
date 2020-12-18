classdef DispClassSetterGetter
  properties
    A
  end
  methods
    function obj = DispClassSetterGetter(a)
      obj.A = a;
    end
    function obj = set.A(obj, a)
      obj.A = a;
      disp('we have set obj.A');
    end
    function a = get.A(obj)
      s = randsample({'🍊', '🍫', '🍛', '🤖'}, 1);
      disp(['f(', num2str(obj.A), ') = ', s{:}]);
      a = obj.A;
    end
    function dispA(obj, n)
      a = obj.A;
      b = a + 5;
      for i = 1:n
        s = num2str(b + i);
        disp(s);
      end
    end
  end
end