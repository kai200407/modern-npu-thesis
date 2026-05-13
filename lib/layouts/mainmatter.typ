#import "../deps.typ": zh
#import "../utils.typ": 字体
#import "header-footer.typ": page-footer, page-header-footer
#import "floats.typ": setup-floats
#import "format.typ": line-spacing

#let mainmatter(
  graduate: false,
  degree: "master",
  english-writing: false,
  leading: line-spacing.bachelor,
  spacing: line-spacing.bachelor,
  heading-above: (),
  heading-below: (),
  heading-numbering: none,
  it,
) = {
  // 图、表、公式、算法样式
  show: setup-floats.with(graduate: graduate, english-writing: english-writing)

  // 页眉页脚
  show: page-header-footer.with(graduate: graduate, degree: degree)

  // 文本和段落样式
  set align(left)
  set par(
    leading: leading,
    justify: true,
    first-line-indent: (amount: 2em, all: true),
    spacing: spacing,
  )

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
      font: 字体.黑体混排,
      size: (zh(3), zh(4), zh(4.5)).at(calc.min(it.level, 3) - 1),
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

  it
}

// 前置部分（摘要、目录）：罗马数字页码 + 标题不编号
#let frontmatter(body) = {
  set page(footer: page-footer("I"))
  set heading(numbering: none)
  counter(page).update(1)
  body
}
