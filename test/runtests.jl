using ImplicitFields
using Base.Test

type Foo
    x::Int
    u::Symbol
end

type Bar
    x::Float32
end

f = Foo(2, :result)
b = Bar(1.6f0)

@test resolve(
    :(u += x * x_post + a * dt),
    f, post=b, dt=1e-3) == :(result += 2 * 1.6f0 + a * 0.001)

