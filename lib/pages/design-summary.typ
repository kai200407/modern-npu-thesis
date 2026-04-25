#import "../utils/style.typ": 字号, 字体
#import "../format.typ": body-format, heading-format
#import "../layouts/preface.typ": preface-heading-style

// 本科毕业设计小结页
#let design-summary(
  twoside: false,
  english-writing: false,
  fonts: (:),
  leading: auto,
  spacing: auto,
  body-font: auto,
  body-size: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  outlined: true,
  title: auto,
  body,
) = {
  fonts = 字体 + fonts
  if body-font == auto { body-font = fonts.宋体 }
  if body-size == auto { body-size = 字号.小四 }
  if leading == auto { leading = body-format.bachelor.leading }
  if spacing == auto { spacing = body-format.bachelor.spacing }
  if title-leading == auto { title-leading = heading-format.bachelor.leading.first() }
  if title-above == auto { title-above = heading-format.bachelor.above.first() }
  if title-below == auto { title-below = heading-format.bachelor.below.first() }
  if title == auto {
    title = if english-writing { "Design Summary" } else { "毕业设计小结" }
  }

  pagebreak(weak: true, to: if twoside { "odd" })
  [
    #set text(font: body-font, size: body-size)
    #set par(leading: leading, justify: true, spacing: spacing, first-line-indent: (amount: 26pt, all: true))

    #show heading.where(level: 1, numbering: none): it => preface-heading-style(
      it,
      fonts,
      leading: title-leading,
      below: title-below,
    )

    #v(title-above)
    #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>

    #body
  ]
}
