#import "../utils/style.typ": 字号, 字体
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/header.typ": header-render

// 西北工业大学研究生中文摘要页
#let master-abstract(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "摘 要",
  outlined: true,
  anonymous-info-keys: ("author", "grade", "supervisor", "supervisor-ii"),
  leading: 1.0em,
  spacing: 1.0em,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "西北工业大学学位论文"),
    author: "张三",
    grade: "20XX",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set par(leading: leading, spacing: spacing, justify: true)

    // 页眉
    #set page(header: header-render([摘　要], fonts: fonts))

    // 标记一个不可见的标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    #align(center)[
      #set text(font: fonts.黑体, size: 字号.三号)

      #v(2em)

      摘　要
    ]

    #v(1em)

    #[
      #set text(font: fonts.宋体, size: 字号.小四)
      #set par(first-line-indent: (amount: 2em, all: true))

      #body
    ]

    #v(1em)

    #h(2em)#text(font: fonts.黑体, size: 字号.小四)[关键词：]#text(font: fonts.宋体, size: 字号.小四)[#(("",)+ keywords.intersperse("；")).sum()]
  ]
}