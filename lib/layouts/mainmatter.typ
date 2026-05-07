#import "@preview/cap-able:0.1.0": cap-style, capfig-style, captab-style, set-table-width
#import "@preview/algorithmic:1.0.7": style-algorithm
#import "../utils/style.typ": 字体, 字号
#import "../utils/custom-numbering.typ": show-equation-handler
#import "../utils/chinese-number.typ": chinese-chapter-number
#import "@preview/hydra:0.6.2": hydra
#import "../utils/header.typ": bachelor-header-render, graduate-header-title, header-render, page-footer
#import "../format.typ": body-format, caption-format

#let mainmatter(
  graduate: false,
  degree: "master",
  english-writing: false,
  leading: body-format.bachelor.leading,
  spacing: body-format.bachelor.spacing,
  heading-above: (),
  heading-below: (),
  heading-numbering: none,
  ..args,
  it,
) = {
  // 算法三线表样式
  show: style-algorithm.with(
    caption-style: body => text(size: 字号.五号, strong(body)),
    hlines: (
      grid.hline(stroke: 1.5pt + black),
      grid.hline(stroke: 1pt + black),
      grid.hline(stroke: 1.5pt + black),
    ),
  )

  set page(
    footer: page-footer("1"),
    header-ascent: 18%,
  )

  // 文本和段落样式
  set align(left)
  set par(
    leading: leading,
    justify: true,
    first-line-indent: (amount: 2em, all: true),
    spacing: spacing,
  )

  set math.equation(supplement: if english-writing { [Equation] } else { [式] })
  show math.equation.where(block: true): show-equation-handler(graduate)


  // 处理标题
  set heading(numbering: heading-numbering)
  show heading: it => {
    if it.level == 1 {
      counter(figure.where(kind: "algorithm")).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }

    set text(
      font: 字体.黑体,
      size: (字号.三号, 字号.四号, 字号.小四).at(calc.min(it.level, 3) - 1),
      weight: "regular",
    )
    set par(first-line-indent: (amount: 0pt))

    let above-extra = if it.level <= heading-above.len() { heading-above.at(it.level - 1) } else { 0pt }
    let below-extra = if it.level <= heading-below.len() { heading-below.at(it.level - 1) } else { 0pt }

    // 一级标题统一换页并居中
    if it.level == 1 {
      pagebreak(weak: true, to: if graduate { "odd" })
      v(leading + above-extra)
      align(center, block(below: leading + below-extra, it))
    } else {
      block(above: leading + above-extra, below: spacing + below-extra, it)
    }
  }

  // 处理页眉
  // hydra 的页眉显示回调：显示编号 + 剥离加粗的标题体
  let hydra-display(ctx, it) = {
    if it.has("numbering") and it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      [ ]
    }
    show strong: it => it.body
    it.body
  }

  set page(header: context {
    let loc = here()
    let header-content = if graduate and calc.rem(loc.page(), 2) == 0 {
      graduate-header-title(degree)
    } else {
      hydra(1, display: hydra-display, use-last: true, skip-starting: false)
    }
    if graduate {
      header-render(header-content)
    } else {
      bachelor-header-render()
    }
  })

  // cap-able 全局样式（共享参数）
  show: cap-style.with(
    numbering-format: "1-1",
    use-chapter: true,
    caption-size: caption-format.size,
    pre-supplement-number-spacing: if english-writing { 0.3em } else { 0em },
  )

  // 表格样式
  show table: set par(justify: false)
  set table(stroke: 0.5pt + black, align: center + horizon)

  if graduate { set-table-width(percentage: 100) }

  // 表格独有配置
  show: captab-style.with(
    three-line-table: if graduate { true } else { false },
    supplement: if english-writing { "Table" } else { "表" },
    body-size: caption-format.size,
    cell-inset: (x: 1em, y: if graduate { 0.55em } else { 0.7em }),
    middle-rule: (paint: black, thickness: 1pt),
    caption-text: if graduate {(font: 字体.宋体)} else {(font: 字体.黑体)},
    caption-below: if graduate {auto} else {10pt},
    table-below: if graduate {auto} else {20pt},
    caption-above: if graduate {auto} else {20pt},
  )
  // 图片独有配置
  show: capfig-style.with(
    supplement: if english-writing { "Figure" } else { "图" },
    show-subcaption: true,
    show-subcaption-label: true,
    label-style: "(a)",
    caption-above: if graduate { auto } else { 10pt },
    figure-below: if graduate {auto} else {20pt},
    figure-above: if graduate {auto} else {20pt},
  )

  it
}

// 前置部分（摘要、目录）：罗马数字页码 + 标题不编号
#let frontmatter(body) = {
  set page(footer: page-footer("I"))
  set heading(numbering: none)
  counter(page).update(1)
  body
}
