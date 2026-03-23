#import "../utils/style.typ": 字体, 字号
#import "../utils/header.typ": graduate-header-title, header-render
#import "../utils/custom-heading.typ": active-heading, heading-display

// 前言
#let preface(
  twoside: false,
  doctype: "master",
  fonts: (:),
  display-header: true,
  ..args,
  it,
) = {
  fonts = 字体 + fonts

  pagebreak(weak: true, to: if twoside { "odd" })
  counter(page).update(1)
  set page(numbering: "I", number-align: center)

  if display-header {
    set page(
      header: context {
        let loc = here()
        let is-graduate = doctype == "master" or doctype == "doctor"
        // 页眉内容
        let header-content = if twoside and calc.rem(loc.page(), 2) == 0 and is-graduate {
          // 偶数页：显示论文标题
          graduate-header-title(doctype)
        } else {
          // 奇数页或单面打印：显示当前标题
          heading-display(active-heading(level: 1, prev: false))
        }
        // 使用统一的页眉渲染
        if header-content != none {
          header-render(header-content, fonts: fonts)
        }
      }
    )
  }

  it
}
