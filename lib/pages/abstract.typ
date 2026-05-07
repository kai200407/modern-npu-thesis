#import "../utils/style.typ": 字号, 字体

// 摘要页
// title: 页面和页眉显示的标题（默认使用 outline-title）
// outline-title: 目录中显示的标题
#let abstract(
  keywords: (),
  keyword-label: "关键词",
  keyword-weight: "regular",
  keyword-sep: "；",
  keyword-indent: true,
  outline-title: "摘　要",
  title: none,
  outlined: true,
  funding: none,
  body,
) = {
  let page-title = if title != none { title } else { outline-title }

  heading(level: 1, outlined: outlined, page-title)

  body

  [
    #set par(first-line-indent: 0pt)
    #v(1em)
    #let indent = if keyword-indent { 2em } else { 0pt }
    #{
      let label = if keyword-weight == "bold" {
        text(font: 字体.黑体, weight: "bold")[#keyword-label：]
      } else {
        [#h(indent)#text(font: 字体.黑体)[#keyword-label]：]
      }
      label + (("",) + keywords.intersperse(keyword-sep)).sum()
    }

    #if funding != none [
      #v(1fr)
      #text(size: 字号.五号)[#h(indent)#funding]
    ]
  ]
}
