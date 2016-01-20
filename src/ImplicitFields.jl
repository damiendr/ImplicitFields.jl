
module ImplicitFields

using DataStructures


list_fields(obj::Any) = fieldnames(obj)
get_field(obj::Any, field::Symbol) = getfield(obj, field)
get_field(obj::Any, field::Void) = obj


function resolve(expr, args...; kwargs...)
    # Build the resolution context, mapping symbols
    # to a container=>field pair:
    context = DefaultDict(Symbol, Vector{Tuple{Any,Any}}, ()->[])

    # args expose their fields directly:
    for obj in args
        for field in list_fields(obj)
            push!(context[field], (obj, field))
        end
    end

    # kwargs expose their fields with a suffix to disambiguate them:
    for (suffix, obj) in kwargs
        for field in list_fields(obj)
            push!(context[Symbol("$(field)_$(suffix)")], (obj, field))
        end
        # also expose the object itself:
        push!(context[suffix], (obj, nothing))
    end

    # Walk the AST and perform the replacements:
    return replace(expr, context)
end
export(resolve)


function replace(s::Symbol, subst)
    if haskey(subst, s)
        matches = subst[s]
        (obj, field) = first(matches)
        if length(matches) > 1
            warn("""Resolving $s to $((obj, field)), but it is ambiguous with """,
                    join(matches[2:end], ", ", " and "))
        end
        return get_field(obj, field)
    end
    return s
end

function replace(expr::Expr, subst)
    args = map(expr.args) do arg
        replace(arg, subst)
    end
    return Expr(expr.head, args...)
end


replace(obj::Any, subst) = obj

end # module
