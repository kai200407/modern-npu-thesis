#import "../utils/style.typ": 字体, 字号
#import "../format.typ": body-format, heading-format
#import "../layouts/preface.typ": preface-heading-style

// 研究生目录页
#let graduate-outline(
  // documentclass 传入参数
  twoside: false,
  english-writing: false,
  fonts: (:),
  // 其他参数
  depth: 4,
  title: auto,
  outlined: false,
  title-vspace: 0pt,
  title-text-args: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  // 引用页数的字体
  reference-font: auto,
  reference-size: auto,
  // 正文字体
  body-font: auto,
  body-size: auto,
  // 目录字体与字号
  font: auto,
  size: auto,
  indent: (0pt, 20pt, 20pt),
  weight: auto,
  // 默认引导符
  fill: auto,
  gap: .3em,
  // 行间距
  leading: auto,
  spacing: auto,
) = {
  fonts = 字体 + fonts

  // 标题默认值
  if title == auto {
    title = if english-writing { "Contents" } else { "目　录" }
  }
  if title-text-args == auto {
    title-text-args = (font: fonts.黑体, size: 字号.三号)
  }
  if title-leading == auto {
    title-leading = heading-format.graduate.leading.first()
  }
  if title-above == auto {
    title-above = heading-format.graduate.above.first()
  }
  if title-below == auto {
    title-below = heading-format.graduate.below.first()
  }
  // 引用页数字体
  if reference-font == auto {
    reference-font = if body-font != auto { body-font } else { fonts.宋体 }
  }
  if reference-size == auto {
    reference-size = if body-size != auto { body-size } else { 字号.小四 }
  }
  // 目录字体与字号
  if font == auto {
    font = (fonts.宋体, fonts.宋体)
  }
  if size == auto {
    size = (字号.小四, 字号.小四)
  }
  if weight == auto {
    weight = ("regular", "regular", "regular")
  }
  if fill == auto {
    fill = (repeat([.], gap: 0.15em),)
  }
  // 行间距
  if leading == auto {
    leading = body-format.graduate.leading
  }
  if spacing == auto {
    spacing = body-format.graduate.spacing
  }

  // 正式渲染
  pagebreak(weak: true, to: "odd")

  set text(font: reference-font, size: reference-size)

  [
    // 目录标题
    #show heading.where(level: 1, numbering: none): it => {
      set text(..title-text-args)
      preface-heading-style(
        it,
        fonts,
        leading: title-leading,
        below: title-below,
      )
    }
    #v(title-above)
    #heading(level: 1, outlined: outlined, title)

    #v(title-vspace)

    // 目录样式
    #set par(leading: leading, spacing: spacing)
    #set outline(indent: level => indent.slice(0, calc.min(level + 1, indent.len())).sum())
    #show outline.entry: entry => {
      let in-mainmatter-or-later = query(
        selector(<__nwpu_mainmatter_start__>).before(entry.element.location()),
      ).len() > 0
      let entry-page-number = counter(page).at(entry.element.location()).first()
      let entry-page-display = if not in-mainmatter-or-later {
        text(font: "Times New Roman")[#numbering("I", entry-page-number)]
      } else {
        text(font: reference-font, size: reference-size)[#numbering("1", entry-page-number)]
      }
      let is-master-abstract-en-entry = (
        query(selector(<__nwpu_master_abstract_en_heading_start__>).before(entry.element.location())).len()
        > query(selector(<__nwpu_master_abstract_en_heading_end>).before(entry.element.location())).len()
      )
      let entry-content = link(
        entry.element.location(),
        entry.indented(
          none,
          {
            text(
              font: font.at(entry.level - 1, default: font.last()),
              size: size.at(entry.level - 1, default: size.last()),
              weight: weight.at(entry.level - 1, default: weight.last()),
              {
                if entry.prefix() not in (none, []) {
                  entry.prefix()
                  h(gap)
                }
                if is-master-abstract-en-entry {
                  [ABSTRACT]
                } else {
                  entry.body()
                }
              },
            )
            box(width: 1fr, inset: (x: .25em), fill.at(entry.level - 1, default: fill.last()))
            entry-page-display
          },
          gap: 0pt,
        ),
      )
      entry-content
    }

    // 显示目录
    #outline(title: none, depth: depth)
  ]
}
