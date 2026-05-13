#import "../layouts/floats.typ": with-numbering-format
#import "../utils.typ": page-title

// 附录布局
#let appendix(
  graduate: false,
  english-writing: false,
  it,
) = {
  let appendix-label = if english-writing {
    "Appendix "
  } else if graduate {
    "附录"
  } else {
    page-title("appendix", graduate: false)
  }

  set heading(numbering: (..nums) => {
    let nums = nums.pos()
    if nums.len() == 1 {
      if not graduate {
        [#appendix-label]
      } else {
        [#appendix-label#numbering("A", nums.at(0))]
      }
    } else if nums.len() <= 3 {
      numbering("A.1", ..nums)
    }
  })
  counter(heading).update(0)

  show: with-numbering-format.with("A-1")

  it
}
