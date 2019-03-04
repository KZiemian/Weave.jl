

#Default options
const defaultParams =
      Dict{Symbol,Any}(:storeresults => false,
                                :doc_number => 0,
                                :chunk_defaults =>
                                Dict{Symbol,Any}(
                                :echo=> true,
                                :results=> "markup",
                                :hold => false,
                                :fig=> true,
                                :include=> true,
                                :eval => true,
                                :tangle => true,
                                :cache => false,
                                :fig_cap=> nothing,
                                #Size in inches
                                :fig_width => 6,
                                :fig_height => 4,
                                :fig_path=> "figures",
                                :dpi => 96,
                                :term=> false,
                                :display => false,
                                :prompt => "\njulia> ",
                                :label=> nothing,
                                :wrap=> true,
                                :line_width => 75,
                                :engine=> "julia",
                                #:option_AbstractString=> "",
                                #Defined in formats
                                :fig_ext => nothing,
                                :fig_pos=> nothing,
                                :fig_env=> nothing,
                                :out_width=> nothing,
                                :out_height=> nothing,
                                :skip=>false
                                )
                            )
#This one can be changed at runtime, initially a copy of defaults
const rcParams = deepcopy(defaultParams)

#Parameters set per document
const docParams =Dict{Symbol,Any}(
                                :fig_path=> nothing,
                                :fig_ext => nothing,
                            )




"""
`set_chunk_defaults(opts::Dict{Symbol, Any})`

Set default options for code chunks, use get_chunk_defaults
to see the current values.

e.g. set default dpi to 200 and fig_width to 8

```
julia> set_chunk_defaults(Dict{Symbol, Any}(:dpi => 200, fig_width => 8))
```
"""
function set_chunk_defaults(opts::Dict{Symbol, Any})
  merge!(rcParams[:chunk_defaults], opts)
  return nothing
end

"""
`get_chunk_defaults()`

Get default options used for code chunks.
"""
function get_chunk_defaults()
  return(rcParams[:chunk_defaults])
end

"""
`restore_chunk_defaults()`

Restore Weave.jl default chunk options
"""
function restore_chunk_defaults()
  rcParams[:chunk_defaults] = defaultParams[:chunk_defaults]
  merge!(rcParams[:chunk_defaults], docParams)
  return nothing
end


getvalue(d::Dict, key , default) = haskey(d, key) ? d[key] : default

"""
`parse_header_options(doc::WeaveDoc)`

Parse document options from document header
"""
function parse_header_options(doc::WeaveDoc)
    args = getvalue(doc.header, "options", Dict())

    doctype = getvalue(args, "doctype", :auto)
    informat = getvalue(args, "informat", :auto)
    out_path = getvalue(args, "out_path", "doc")
    out_path == ":pwd" && (out_path = :pwd)
    mod = Symbol(getvalue(args, "mod", :sandbox))
    fig_path = getvalue(args, "fig_path", "figures")
    fig_ext = getvalue(args, "fig_ext", nothing)
    cache_path = getvalue(args, "cache_path", "cache")
    cache = Symbol(getvalue(args, "cache", :off))
    throw_errors = getvalue(args, "throw_errors", false)
    template = getvalue(args, "template", nothing)
    highlight_theme = getvalue(args, "highlight_theme", nothing)
    css = getvalue(args, "css", nothing)
    pandoc_options = getvalue(args, "pandoc_options", String[])
    latex_cmd = getvalue(args, "latex_cmd", "xelatex")

    return (doctype, informat, out_path, args, mod, fig_path, fig_ext,
      cache_path, cache, throw_errors, template, highlight_theme, css,
      pandoc_options, latex_cmd)
end
