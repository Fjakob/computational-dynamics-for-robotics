function M = M(obj, q)
n = obj.N;
bodies = obj.Bodies;
parent = obj.Parents;
M = zeros(n, n);
for i = 1:n
    b = bodies(i);
    T_ip = b.T(q(i));
    X_ip = Math.AdT(T_ip);
    Ici = b.I;
    b.store('X', X_ip, 'Ic', Ici);
end

for i = n:-1:1
    b = bodies(i);
    Ai = b.A;
    Ici = b.var('Ic');
    
    k = parent(i);
    if k > 0
        p = bodies(k);
        X_ip = b.var('X');
        p.store('Ic', p.var('Ic') + transpose(X_ip) * Ici * X_ip);
    end
    
    F = Ici * Ai;
    M(i, i) = transpose(Ai) * F;
    j = i;
    k = parent(j);
    while k > 0
        X_jp = bodies(j).var('X');
        F = transpose(X_jp) * F;
        j = k;
        Aj = bodies(j).A;
        M(i, j) = transpose(F) * Aj;
        M(j, i) = M(i, j);
        k = parent(j);
    end
end
end
