#import "@preview/i-figured:0.2.4"
#import "../utils/style.typ": 字体, 字号
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": active-heading, heading-display
#import "../utils/unpairs.typ": unpairs
#import "../utils/header.typ": bachelor-header-render, graduate-header-title, header-render
#import "../format.typ": body-format, heading-format, caption-format, header-format

// 一级标题间距，用于二级三级标题间距计算
#let level1-heading-above = heading-format.graduate.above.first()
#let level1-heading-below = heading-format.graduate.below.first()

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  doctype: "bachelor",
  english-writing: false,
  graduate-leading: body-format.graduate.leading,
  graduate-spacing: body-format.graduate.spacing,
  bachelor_leading: body-format.bachelor.leading,
  bachelor_spacing: body-format.bachelor.spacing,
  bachelor_heading_leading: heading-format.bachelor.leading,
  bachelor_heading_above: heading-format.bachelor.above,
  bachelor_heading_below: heading-format.bachelor.below,
  fonts: (:),
  // 其他参数
  leading: auto,
  spacing: auto,
  justify: true,
  first-line-indent: auto,
  heading-numbering: auto,
  // 正文字体与字号参数
  text-args: auto,
  // 本科正文字体（统一控制参数）
  body-font: auto,
  body-size: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (字号.三号, 字号.四号, 字号.小四),
  heading-weight: ("regular", "regular", "regular"),
  heading_leading: auto,
  // 一级标题使用统一配置，二三级保持原有值
  heading-above: auto,
  heading-below: auto,
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
  // 1.  默认参数（提前初始化 fonts）
  fonts = 字体 + fonts
  let is-graduate = doctype == "master" or doctype == "doctor"
  let table-kinds = (table, "i-figured-table")
  let show-equation-handler = if is-graduate {
    i-figured.show-equation.with(
      numbering: (..nums) => text(font: "Times New Roman")[#numbering("(1-1)", ..nums)],
    )
  } else {
    i-figured.show-equation.with(
      numbering: (..nums) => text(font: fonts.宋体)[（#text(font: "Times New Roman")[#numbering("1-1", ..nums)]）],
    )
  }
  let chinese_chapter_number(n) = {
    let digits = ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九")
    if n <= 10 {
      if n == 10 { "十" } else { digits.at(n) }
    } else if n < 20 {
      "十" + digits.at(calc.rem(n, 10))
    } else if calc.rem(n, 10) == 0 {
      digits.at(calc.floor(n / 10)) + "十"
    } else {
      digits.at(calc.floor(n / 10)) + "十" + digits.at(calc.rem(n, 10))
    }
  }
  if leading == auto {
    leading = if is-graduate { graduate-leading } else { bachelor_leading }
  }
  if spacing == auto {
    spacing = if is-graduate { graduate-spacing } else { bachelor_spacing }
  }
  if first-line-indent == auto {
    first-line-indent = if is-graduate {
      (amount: 2em, all: true)
    } else {
      (amount: 26pt, all: true)
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
        first-level: n => [第#chinese_chapter_number(n)章　],
        depth: 4,
        "1.1 ",
      )
    }
  }
  if text-args == auto {
    if body-font == auto { body-font = fonts.宋体 }
    if body-size == auto { body-size = 字号.小四 }
    text-args = (font: body-font, size: body-size)
  }
  let bachelor-figure-gap = text-args.at("size", default: 字号.小四) + leading
  // 1.1 字体与字号
  if heading-font == auto {
    heading-font = (fonts.黑体,)
  }
  if heading_leading == auto {
    heading_leading = if is-graduate {
      (graduate-leading, graduate-leading, graduate-leading)
    } else {
      bachelor_heading_leading
    }
  }
  if heading-above == auto {
    heading-above = if is-graduate {
      (level1-heading-above, 2 * 15.6pt - 0.7em, 2 * 15.6pt - 0.7em)
    } else {
      bachelor_heading_above
    }
  }
  if heading-below == auto {
    heading-below = if is-graduate {
      (level1-heading-below, 1.5 * 15.6pt - 0.7em, 1.5 * 15.6pt - 0.7em)
    } else {
      bachelor_heading_below
    }
  }

  // 双面打印时确保正文从奇数页开始
  pagebreak(weak: true, to: if twoside { "odd" })

  // 重置页码为阿拉伯数字从1开始
  counter(page).update(1)
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
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: spacing,
  )
  show raw: set text(font: fonts.等宽)
  // 4.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // 4.3 设置 figure 的编号
  show heading: i-figured.reset-counters
  let figure-show-handler = i-figured.show-figure.with(numbering: "1-1")
  show figure: it => {
    let rendered = figure-show-handler(it)
    if is-graduate {
      rendered
    } else {
      block(above: bachelor-figure-gap, below: bachelor-figure-gap)[#rendered]
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
      text(font: fonts.黑体, size: 字号.五号)[
        #it.supplement
        #h(0.08em)
        #context it.counter.display(it.numbering)
        #h(0.28em)
        #it.body
      ]
    } else {
      text(font: fonts.宋体, size: 字号.五号)[#it]
    }
  }
  // 表格内容使用五号字体
  show table: set text(font: fonts.宋体, size: 字号.五号)
  // 4.6 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  // 5.  处理标题
  // 5.1 设置标题的 Numbering
  set heading(numbering: heading-numbering)
  // 5.2 设置字体、字号、换页及段前段后间距
  show heading: it => {
    if it.level == 1 {
      counter(figure.where(kind: "algorithm")).update(0)
    }

    // 无编号一级标题（如致谢、参考文献、成果页等）不应继续沿用正文标题版式，
    // 否则会把正文的段前距和换页规则叠加到后置部分页面上。
    if is-graduate and it.level == 1 and it.numbering == none {
      return it
    }

    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set par(leading: array-at(heading_leading, it.level), spacing: 0pt)

    let needs-pagebreak = false
    if array-at(heading-pagebreak, it.level) {
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        needs-pagebreak = true
      }
    }

    if needs-pagebreak {
      if it.level == 1 {
        // 如果是双面打印，一级标题换页需要跳转到奇数页
        pagebreak(weak: true, to: if twoside { "odd" })
      } else {
        pagebreak(weak: true)
      }
      // 手动添加页首被忽略的顶部间距
      v(array-at(heading-above, it.level))
    }

    // 设置段前段后间距。如果有换页，则 block() 的 above 设为 0pt 防止双倍间距
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
              fonts: fonts,
              graduate_headsep: graduate_headsep,
              graduate_headrule_offset: graduate_headrule_offset,
              graduate_headrule_thick: graduate_headrule_thick,
              graduate_headrule_thin: graduate_headrule_thin,
              graduate_headrule_gap: graduate_headrule_gap,
            )
          } else {
            bachelor-header-render()
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

  it
}
