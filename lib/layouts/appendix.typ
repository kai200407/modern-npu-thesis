#import "@preview/i-figured:0.2.4"
#import "@preview/cap-able:0.0.2": captab-style, capfig-style
#import "../utils/style.typ": 字号
#import "../utils/custom-numbering.typ": custom-numbering

// 附录布局
#let appendix(
  doctype: "bachelor",
  english-writing: false,
  it,
) = {
  let appendix-label = if english-writing {
    "Appendix "
  } else if doctype == "bachelor" {
    "附 录"
  } else {
    "附录"
  }

  set heading(numbering: if doctype == "bachelor" {
    custom-numbering.with(
      first-level: n => [#appendix-label],
      depth: 4,
      "A.1 ",
    )
  } else {
    custom-numbering.with(
      first-level: n => [#appendix-label#numbering("A", n)],
      depth: 4,
      "A.1 ",
    )
  })
  counter(heading).update(0)

  let is-graduate = doctype == "graduate"

  show: captab-style.with(numbering-format: "A-1", use-chapter: true)
  show: capfig-style.with(numbering-format: "A-1", use-chapter: true)
  let figure-show-handler = i-figured.show-figure.with(numbering: "A-1")
  show figure: it => {
    if it.kind == image or (is-graduate and it.kind == table) {
      it
    } else {
      figure-show-handler(it)
    }
  }
  show math.equation.where(block: true): if doctype == "bachelor" {
    i-figured.show-equation.with(
      numbering: (..nums) => {
        let eq-number = numbering("A-1", ..nums)
        [（#eq-number）]
      },
    )
  } else {
    i-figured.show-equation.with(
      numbering: "(A-1)",
    )
  }

  it
}
