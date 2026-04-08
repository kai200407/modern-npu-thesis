#import "../utils/style.typ": 字号, 字体
#import "../layouts/preface.typ": preface-heading-style, preface-heading-above

// 本科毕业设计小结页
#let design-summary(
  twoside: false,
  fonts: (:),
  leading: 2.4pt,
  spacing: 0pt,
  outlined: true,
  title: "毕业设计小结",
  body,
) = {
  fonts = 字体 + fonts

  pagebreak(weak: true, to: if twoside { "odd" })
  [
    #set text(font: fonts.宋体, size: 字号.小四)
    #set par(leading: leading, justify: true, spacing: spacing, first-line-indent: (amount: 26pt, all: true))

    #show heading.where(level: 1, numbering: none): it => preface-heading-style(it, fonts, leading: leading)

    #v(preface-heading-above)
    #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>

    #body
  ]
}
