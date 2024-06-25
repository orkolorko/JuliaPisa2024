function orbit(T, x0, N; transient = N)
    orb = zeros(typeof(x0), N)
    x = x0

    for _ in 1:transient 
        x = T(x)
    end

    for i in 1:N
        orb[i] = x
        x = T(x)
    end
    return orb
end