#import "../utils/style.typ": 字体, 字号
#import "../layouts/preface.typ": preface-heading-style, preface-heading-above, preface-heading-below, preface-heading-leading, preface-body-leading, preface-body-spacing, preface-body-first-line-indent

// 西北工业大学研究生学术成果页
#let academic-achievements(
  // documentclass 传入参数
  anonymous: false,
  twoside: false,
  english-writing: false,
  fonts: (:),
  // 其他参数
  title: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  outlined: true,
  body,
) = {
  fonts = 字体 + fonts
  if title == auto {
    title = if english-writing {
      "Academic Achievements and Research Experience"
    } else {
      "在学期间取得的学术成果和参加科研情况"
    }
  }
  if title-leading == auto {
    title-leading = preface-heading-leading
  }
  if title-above == auto {
    title-above = preface-heading-above
  }
  if title-below == auto {
    title-below = preface-heading-below
  }

  if not anonymous {
    pagebreak(weak: true, to: if twoside { "odd" })
    [
      #set text(font: fonts.宋体, size: 字号.小四)
      #set par(
        leading: preface-body-leading,
        spacing: preface-body-spacing,
        justify: true,
        first-line-indent: preface-body-first-line-indent,
      )

      // 覆盖正文阶段遗留的 heading show 规则，避免无编号一级标题被重复叠加段前距
      #show heading: it => {
        if it.level == 1 and it.numbering == none {
          preface-heading-style(it, fonts, leading: title-leading, below: title-below)
        } else {
          it
        }
      }

      #v(title-above)
      #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>

      #body
    ]
  }
}
