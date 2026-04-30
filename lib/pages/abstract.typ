#import "../utils/style.typ": 字号, 字体

// 摘要页
#let abstract(
  keywords: (),
  keyword-label: "关键词",
  keyword-weight: "regular",
  keyword-sep: "；",
  keyword-indent: 2em,
  outline-title: "摘　要",
  outlined: true,
  keywords-above: 1em,
  funding: none,
  body,
) = {
  [
    // 目录显示 "ABSTRACT"，页面显示 "Abstract"
    #show heading.where(level: 1): it => {
      if it.body == [ABSTRACT] {
        heading(level: it.level, outlined: false)[Abstract]
      } else {
        it
      }
    }
    #heading(level: 1, outlined: outlined, outline-title)
  ]

  body

  [
    #set par(first-line-indent: 0pt)
    #v(keywords-above)
    #if keyword-weight == "bold" [
      #text(font: 字体.黑体, weight: "bold")[#keyword-label：]
    ] else [
      #h(keyword-indent)#text(font: 字体.黑体)[#keyword-label]：
    ]
    #(("",) + keywords.intersperse(keyword-sep)).sum()
  ]

  if funding != none [
    #v(1fr)
    #set par(leading: 1.4em)
    #text(size: 字号.五号)[#funding]
  ]
}
