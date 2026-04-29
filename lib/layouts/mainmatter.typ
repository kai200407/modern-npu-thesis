#import "@preview/i-figured:0.2.4"
#import "@preview/cap-able:0.0.2": captab-style, capfig-style
#import "../utils/style.typ": 字体, 字号
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": active-heading, heading-display
#import "../utils/unpairs.typ": unpairs
#import "../utils/chinese-number.typ": chinese-chapter-number
#import "../utils/header.typ": bachelor-header-render, graduate-header-title, header-render
#import "../format.typ": body-format, heading-format, caption-format, header-format, table-format

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  doctype: "bachelor",
  english-writing: false,
  // 正文段落格式
  leading: body-format.bachelor.leading,
  spacing: body-format.bachelor.spacing,
  justify: true,
  first-line-indent: auto,
  heading-numbering: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (字号.三号, 字号.四号, 字号.小四),
  heading-weight: ("regular", "regular", "regular"),
  heading_leading: heading-format.bachelor.leading,
  heading-above: heading-format.bachelor.above,
  heading-below: heading-format.bachelor.below,
  heading-pagebreak: (true, false, false),
  heading-align: (center, auto, auto),
  // 页眉
  display-header: false,
  stroke-width: 0.5pt,
  reset-footnote: true,
  graduate_headsep: header-format.graduate.headsep,
  graduate_headrule_offset: header-format.graduate.headrule-offset,
  graduate_headrule_thick: header-format.graduate.headrule-thick,
  graduate_headrule_thin: header-format.graduate.headrule-thin,
  graduate_headrule_gap: header-format.graduate.headrule-gap,
  // caption 的 separator
  separator: caption-format.separator,
  // caption 样式（宋体五号不加粗）
  caption-style: it => it,
  caption-size: caption-format.size,
  // figure 计数
  show-figure: i-figured.show-figure.with(numbering: "1-1"),
  ..args,
  it,
) = {
  let is-graduate = doctype == "graduate"
  let table-kinds = (table, "i-figured-table")
  let show-equation-handler = if is-graduate {
    i-figured.show-equation.with(
      numbering: (..nums) => numbering("(1-1)", ..nums),
    )
  } else {
    i-figured.show-equation.with(
      numbering: (..nums) => [（#numbering("1-1", ..nums)）],
    )
  }
  if first-line-indent == auto {
    first-line-indent = if is-graduate {
      body-format.graduate.first-line-indent
    } else {
      body-format.bachelor.first-line-indent
    }
  }
  if heading-numbering == auto {
    heading-numbering = if english-writing {
      custom-numbering.with(
        first-level: n => [Chapter #n#h(0.7em)],
        depth: 4,
        "1.1 ",
      )
    } else if is-graduate {
      custom-numbering.with(
        first-level: n => [第 #n 章#h(0.7em)],
        depth: 4,
        "1.1 ",
      )
    } else {
      custom-numbering.with(
        first-level: n => [第#chinese-chapter-number(n)章　],
        depth: 4,
        "1.1 ",
      )
    }
  }
  let bachelor-figure-gap = 字号.小四 + leading
  // 1.1 字体与字号
  if heading-font == auto {
    heading-font = (字体.黑体,)
  }

  // 重置页码为阿拉伯数字从1开始（由调用方在正文开始位置处理 pagebreak 和 counter reset）
  set page(
    footer: context align(center)[
      #set text(size: 字号.小五)
      #counter(page).display("1")
    ],
  )

  // 2.  处理 heading- 开头的其他参数
  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 3.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 4.  设置基本样式
  // 4.1 文本和段落样式
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: spacing,
  )
  // 4.2 设置 figure 的编号
  show heading: i-figured.reset-counters
  let figure-show-handler = i-figured.show-figure.with(numbering: "1-1")
  show figure: it => {
    // 研究生跳过表格和图片类 figure，由 cap-able 处理编号
    if is-graduate and (it.kind == table or it.kind == image) {
      it
    } else if it.kind == image {
      // 本科图片也由 cap-able 的 capfig() 处理编号
      it
    } else {
      let rendered = figure-show-handler(it)
      if is-graduate {
        rendered
      } else {
        block(above: bachelor-figure-gap, below: bachelor-figure-gap)[#rendered]
      }
    }
  }
  set figure(supplement: if english-writing { [Figure] } else { [图] })
  show figure.where(kind: table): set figure(supplement: if english-writing { [Table] } else { [表] })
  show figure.where(kind: "i-figured-table"): set figure(supplement: if english-writing { [Table] } else { [表] })
  // 4.4 设置 equation 的编号和假段落首行缩进
  set math.equation(supplement: if english-writing { [Equation] } else { [式] })
  show math.equation.where(block: true): show-equation-handler
  // 4.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)
  show figure.where(
    kind: "i-figured-table",
  ): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: it => {
    if not is-graduate and it.kind in table-kinds {
      text(font: 字体.黑体, size: 字号.五号)[
        #it.supplement
        #h(0.08em)
        #context it.counter.display(it.numbering)
        #h(0.28em)
        #it.body
      ]
    } else {
      text(size: 字号.五号)[#it]
    }
  }
  // 表格内容使用五号字体
  show table: set text(size: 字号.五号)
  set table(
    stroke: if is-graduate { none } else { 0.5pt },
    inset: (x: 0.3em, y: if is-graduate { 0.5em } else { 0.7em }),
    align: center + horizon,
  )

  // 5.  处理标题
  // 5.1 设置标题的 Numbering
  set heading(numbering: heading-numbering)
  // 5.2 设置字体、字号、换页及段后段后间距
  show heading: it => {
    if it.level == 1 {
      counter(figure.where(kind: "algorithm")).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: "i-figured-table")).update(0)
    }

    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set par(leading: array-at(heading_leading, it.level), spacing: 0pt)

    // 所有符合 heading-pagebreak 配置的一级标题统一换页（包括无编号标题）
    let needs-pagebreak = false
    if array-at(heading-pagebreak, it.level) {
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        needs-pagebreak = true
      }
    }

    if needs-pagebreak {
      if it.level == 1 {
        pagebreak(weak: true, to: if twoside { "odd" })
      } else {
        pagebreak(weak: true)
      }
      v(array-at(heading-above, it.level))
    }

    let current-block-above = if needs-pagebreak { 0pt } else { array-at(heading-above, it.level) }
    let current-block-below = array-at(heading-below, it.level)

    if array-at(heading-align, it.level) != auto {
      set align(array-at(heading-align, it.level))
      set block(above: current-block-above, below: current-block-below)
      it
    } else {
      set block(above: current-block-above, below: current-block-below)
      it
    }
  }

  // 6.  处理页眉
  set page(..(
    if display-header {
      (
        header: context {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }
          let loc = here()
          // 页眉内容
          let header-content = if twoside and calc.rem(loc.page(), 2) == 0 and is-graduate {
            // 偶数页：显示论文标题
            graduate-header-title(doctype)
          } else {
            // 奇数页或单面打印：显示当前章标题
            heading-display(active-heading(level: 1, prev: false))
          }
          // 使用统一的页眉格式
          if is-graduate {
            header-render(
              header-content,
              graduate_headsep: graduate_headsep,
              graduate_headrule_offset: graduate_headrule_offset,
              graduate_headrule_thick: graduate_headrule_thick,
              graduate_headrule_thin: graduate_headrule_thin,
              graduate_headrule_gap: graduate_headrule_gap,
            )
          } else {
            bachelor-header-render(offset: header-format.bachelor.offset)
          }
        },
      )
    } else {
      (
        header: {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }
        },
      )
    }
  ))

  // 研究生使用 cap-able 配置三线表全局样式
  if is-graduate {
    show: captab-style.with(
      numbering-format: "1-1",
      use-chapter: true,
      supplement: "表",
      caption-size: caption-size,
      caption-weight: "regular",
      body-size: 字号.五号,
      cell-inset: (x: 0.3em, y: 0.5em),
      enable-english-caption: false,
      pre-supplement-number-spacing: 0em,
      number-title-spacing: [\u{3000}],
      middle-rule: (paint: black, thickness: 1pt),
    )
  }

  // 使用 cap-able 配置图片全局样式
  show: capfig-style.with(
    numbering-format: "1-1",
    use-chapter: true,
    supplement: "图",
    caption-size: caption-size,
    caption-weight: "regular",
    enable-english-caption: false,
    pre-supplement-number-spacing: 0em,
    number-title-spacing: [\u{3000}],
    show-subcaption: true,
    show-subcaption-label: true,
    label-style: "(a)",
    gutter: 1em,
  )

  it
}

// 前置部分（摘要、目录）：罗马数字页码 + 标题不编号
#let frontmatter(body) = {
  set page(footer: context align(center)[
    #set text(size: 字号.小五)
    #counter(page).display("I")
  ])
  set heading(numbering: none)
  counter(page).update(1)
  body
}
