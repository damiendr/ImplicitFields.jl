# ImplicitFields

[![Build Status](https://travis-ci.org/damiendr/ImplicitFields.jl.svg?branch=master)](https://travis-ci.org/damiendr/ImplicitFields.jl)

A metaprogramming tool for Julia that resolves implicit and suffixed references in quoted expressions. The primary use is to parse equation-like expressions and bind names to object fields.

## Basic Usage

The main function, `resolve(expr, args...; kwargs...)` expects both optional and keyword arguments.
These provide the resolution context, with the following conventions:

- the fields of objects passed as optional arguments can be accessed directly: `x`
- the fields of objects passed as keyword arguments must be suffixed with the keyword: `x_target`
- objects passed as keyword arguments can also be accessed themselves under the keyword's name.
- symbols that cannot be resolved are left as-is.

```julia
using ImplicitFields

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

You can create custom handlers for a particular type by implementing the following methods, shown below with their default behaviour:

```julia
list_fields(obj::Any) = fieldnames(obj)
get_field(obj::Any, field::Symbol) = getfield(obj, field)
get_field(obj::Any, field::Void) = obj
```

