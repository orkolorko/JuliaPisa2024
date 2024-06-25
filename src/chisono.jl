chisono(x::Int64) = print("Sono un intero!")
chisono(x::Float64) = print("Sono un float!")
#chisono(x) = print("Non lo so!")

chisono(x::T) where {T} = print("Sono un $T")  