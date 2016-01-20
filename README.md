# ImplicitFields

[![Build Status](https://travis-ci.org/damiendr/ImplicitFields.jl.svg?branch=master)](https://travis-ci.org/damiendr/ImplicitFields.jl)

Resolves implicit and suffixed references in quoted expressions.

## Basic Usage

```julia
type Foo
    x::Int
    u::Symbol
end

type Bar
    x::Float32
end

f = Foo(2, :result)
b = Bar(1.6f0)

resolve(quote
    u += x * x_post + a * dt
end, f, post=b, dt=1e-3)
```

results in :
```
quote
    result += 2 * 1.6f0 + a * 0.001
end
```

## Custom Resolvers

You can create custom handlers for a particular type by overriding the following methods, shown below with their default behaviour:

```julia
list_fields(obj::Any) = fieldnames(obj)
get_field(obj::Any, field::Symbol) = getfield(obj, field)
get_field(obj::Any, field::Void) = obj
```

