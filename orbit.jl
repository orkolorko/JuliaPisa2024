function orbit(T, x0::Float64, N)
    orb = zeros(Float64, N)
    x = x0
    for i in 1:N
        orb[i] = x
        x = T(x)
    end
    return orb
end

function orbit(T, x0, N)
    orb = zeros(typeof(x0), N)
    x = x0
    for i in 1:N
        orb[i] = x
        x = T(x)
    end
    return orb
end