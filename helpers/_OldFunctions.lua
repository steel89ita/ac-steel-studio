--[[ local function generateBackgroundsTable(data, targetTable)
  for i, bkg in ipairs(data) do
    --ac.console(i)
    local r, g, b, m = string.match(bkg.color, '([%d.]+), ([%d.]+), ([%d.]+), ([%d.]+)')

    local content = {
      meshNames = bkg.meshNames,
      color = rgbm(tonumber(r), tonumber(g), tonumber(b), tonumber(m)),
      texture = bkg.texture,
      label = bkg.label
    }

    table.insert(targetTable, content)
  end
end ]]
