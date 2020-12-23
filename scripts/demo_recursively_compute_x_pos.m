function x = demo_recursively_compute_x_pos(n, delta_x)
  % DEMO_RECURSIVELY_COMPUTE_X_POS Computes the x-position of frame {n}
  % relative to {0}.
  %   X = DEMO_RECURSIVELY_COMPUTE_X_POS(N, DELTA_X) Returns the absolute
  %   position of the x-position of frame {n} relative to {0}.  N is frame
  %   {N} and DELTA_X is an array of relative offsets, where the i^th
  %   element is the relative position of frame {i} relative to frame {i -
  %   1}.
  %
  %   Example:
  %     n = 3;
  %     delta_x = ones(1, n);
  %     x = demo_recursively_compute_x_pos(n, delta_x)
  %
  %     >> 3

  fprintf('computing frame {%d} relative to {0}...', n);
  if n == 0 
    x = 0;
    fprintf('we have reached the base case!\n');
    fprintf('\t* the x-position of {0} in {0} is zero.\n');
    fprintf('\t* we will now head back "up" the call chain.\n');
  else 
    fprintf('\n\t* need to compute {%d} relative to {0} first!\n', n - 1);
    x = demo_recursively_compute_x_pos(n - 1, delta_x) + delta_x(n); 
    fprintf('frame {%d} here again.\n', n);
    fprintf('\t*{%d} relative to {0} is %f!\n', n, x);
  end
end