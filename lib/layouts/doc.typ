// 文稿设置，可以进行一些像页面边距这类的全局设置
#import "../deps.typ": show-cn-fakebold
#import "../utils/style.typ": 字体, 字号

#let doc(
  margin: auto,
  it,
) = {
  show: show-cn-fakebold
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh")
  set par(leading: 12pt, spacing: 12pt)
  set align(center)
  set table(stroke: none, align: center, inset: (x: 0pt, y: 4pt))
  set page(
    paper: "a4",
    margin: margin,
  )

  it
}
