#import "../utils/style.typ": 字体, 字号
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/header.typ": header-render

// 西北工业大学研究生英文摘要页
#let master-abstract-en(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "Abstract",
  outlined: true,
  anonymous-info-keys: ("author-en", "supervisor-en", "supervisor-ii-en"),
  leading: 1.5em,
  spacing: 1.5em,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    (
      title-en: "NPU Thesis Template for Typst",
      author-en: "Zhang San",
      department-en: "XX School",
      major-en: "XX",
      supervisor-en: "Li Si",
    )
      + info
  )

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  // 3.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set par(leading: leading, spacing: spacing, justify: true)

    // 页眉
    #set page(header: header-render([Abstract], fonts: fonts))

    // 标记一个不可见的标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    #align(center)[
      #set text(font: fonts.黑体, size: 字号.三号, weight: "bold")

      #v(2em)

      Abstract
    ]

    #v(1em)

    #[
      #set text(font: fonts.宋体, size: 字号.小四)
      #set par(first-line-indent: (amount: 2em, all: true))

      #body
    ]

    #v(1em)

    #text(size: 字号.小四)[
      Key words: #(("",) + keywords.intersperse("; ")).sum()
    ]
  ]
}
