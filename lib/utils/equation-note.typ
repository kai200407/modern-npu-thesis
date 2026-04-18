#import "../utils/style.typ": 字体, 字号
#import "../utils/algorithm.typ": english-writing-state

#let equation-note(prefix: auto, body) = context {
  let resolved-prefix = if prefix == auto {
    if english-writing-state.get() {
      [where ]
    } else {
      [式中，]
    }
  } else {
    prefix
  }

  block(width: 100%)[
    #set par(first-line-indent: 0pt, justify: false)
    #set text(size: 字号.五号, font: 字体.宋体)
    #if resolved-prefix != none [#resolved-prefix]
    #body
  ]
}
