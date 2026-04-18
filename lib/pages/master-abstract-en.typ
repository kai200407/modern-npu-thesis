#import "../utils/style.typ": 字体, 字号
#import "../utils/header.typ": header-render
#import "../layouts/preface.typ": (
  preface-heading-above, preface-heading-below, preface-heading-style, preface-body-first-line-indent,
  preface-keywords-above,
)

#let master-abstract-en(
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  keywords: (),
  outline-title: "Abstract",
  outlined: true,
  anonymous-info-keys: ("author-en", "supervisor-en", "supervisor-ii-en"),
  leading: 1.0em,
  spacing: 1.0em,
  title-leading: 2.4pt,
  title-above: preface-heading-above,
  title-below: preface-heading-below,
  funding: none,
  body,
) = {
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

  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  pagebreak(weak: true, to: if twoside { "odd" })


  [
    #set par(leading: leading, spacing: spacing, justify: true)

    // 英文摘要标题复用统一标题样式，只覆盖字体与字重
    #show heading.where(level: 1): it => {
      preface-heading-style(
        it,
        fonts,
        font: "Times New Roman",
        weight: "bold",
        leading: title-leading,
        below: title-below,
      )
    }
    #v(title-above)
    <__nwpu_master_abstract_en_heading_start__>
    #heading(level: 1, outlined: outlined, outline-title)<__nwpu_master_abstract_en_heading_end__>

    #[
      #set text(font: "Times New Roman", size: 字号.小四)
      #set par(first-line-indent: preface-body-first-line-indent)
      #body
    ]

#v(preface-keywords-above)
#text(font: "Times New Roman", size: 字号.小四)[
  #strong[Key words]#text(font: fonts.黑体, weight: "bold")[：]#(("",) + keywords.intersperse("; ")).sum()
]

    #v(1fr)

    #if funding != none [
      #set par(leading: 1.4em)
      #text(font: fonts.宋体, size: 字号.五号)[#funding]
    ]
  ]
}
