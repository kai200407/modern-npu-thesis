#import "../utils/style.typ": 字体, 字号
#import "../format.typ": body-format, heading-format
#import "../utils/header.typ": header-render
#import "../layouts/preface.typ": preface-heading-style, preface-body-first-line-indent, preface-keywords-above

#let master-abstract(
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  keywords: (),
  outline-title: "摘　要",
  outlined: true,
  anonymous-info-keys: ("author", "grade", "supervisor"),
  leading: auto,
  spacing: auto,
  body-font: auto,
  body-size: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  keywords-above: preface-keywords-above,
  funding: none,
  body,
) = {
  fonts = 字体 + fonts
  if body-font == auto { body-font = fonts.宋体 }
  if body-size == auto { body-size = 字号.小四 }
  if leading == auto { leading = body-format.graduate.leading }
  if spacing == auto { spacing = body-format.graduate.spacing }
  if title-leading == auto { title-leading = heading-format.graduate.leading.first() }
  if title-above == auto { title-above = heading-format.graduate.above.first() }
  if title-below == auto { title-below = heading-format.graduate.below.first() }
  info = (
    (
      title: ("基于 Typst 的", "西北工业大学学位论文"),
      author: "张三",
      grade: "20XX",
      department: "某学院",
      major: "某专业",
      supervisor: ("李四", "教授"),
    )
      + info
  )

  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set par(leading: leading, spacing: spacing, justify: true)

    // 使用统一的一级标题样式
    #show heading.where(level: 1): it => preface-heading-style(it, fonts, leading: title-leading, below: title-below)
    #v(title-above)
    #heading(level: 1, outlined: outlined, outline-title)

    #[
      #set text(font: body-font, size: body-size)
      #set par(first-line-indent: preface-body-first-line-indent)
      #body
    ]

#v(keywords-above)
#h(2em)#text(font: fonts.黑体, size: body-size)[关键词：]#text(font: body-font, size: body-size)[#(
  ("",) + keywords.intersperse("；")
).sum()]

    #v(1fr)

    #if funding != none [
      #set par(first-line-indent: (amount: 2em, all: true), leading: 1.4em)
      #text(font: fonts.宋体, size: 字号.五号)[#funding]
    ]
  ]
}
