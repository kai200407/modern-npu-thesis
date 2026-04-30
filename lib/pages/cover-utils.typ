// 封面共享工具

// 信息行：标签 + 下划线值（用于封面表格）
#let info-row(label, value, stroke-width: 0.5pt) = (
  table.cell([#label]),
  table.cell(stroke: (bottom: stroke-width), [#value]),
)
