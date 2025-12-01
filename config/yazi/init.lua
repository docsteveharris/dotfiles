require("full-border"):setup({
  -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
  type = ui.Border.PLAIN,
})

-- https://yazi-rs.github.io/docs/tips#symlink-in-status
Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end, 3300, Status.LEFT)

-- DuckDB plugin configuration
require("duckdb"):setup()
