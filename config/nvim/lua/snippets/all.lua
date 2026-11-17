local ls = require("luasnip")

local function timestamp(format)
  return function()
    return os.date(format)
  end
end

return {
  ls.snippet(
    { trig = "date", name = "Current date", dscr = "Insert the current date" },
    { ls.function_node(timestamp("%Y-%m-%d"), {}) }
  ),
  ls.snippet(
    { trig = "datetime", name = "Current date and time", dscr = "Insert the current ISO-style timestamp" },
    { ls.function_node(timestamp("%Y-%m-%dT%H:%M:%S%z"), {}) }
  ),
  ls.snippet(
    { trig = "todo", name = "TODO marker", dscr = "Insert a TODO marker" },
    { ls.text_node("TODO: "), ls.insert_node(0) }
  ),
  ls.snippet(
    { trig = "fixme", name = "FIXME marker", dscr = "Insert a FIXME marker" },
    { ls.text_node("FIXME: "), ls.insert_node(0) }
  ),
}
