
#import "../utils/style.typ": 字号, 字体
#import "../layouts/preface.typ": preface-heading-style, preface-heading-above, preface-heading-below, preface-heading-leading, preface-body-leading, preface-body-spacing, preface-body-first-line-indent

// 致谢页
#let acknowledgement(
  // documentclass 传入参数
  anonymous: false,
  twoside: false,
  doctype: "master",
  english-writing: false,
  leading: auto,
  spacing: auto,
  body-font: auto,
  body-size: auto,
  title-leading: auto,
  title-above: auto,
  title-below: auto,
  fonts: (:),
  // 其他参数
  title: auto,
  outlined: true,
  body,
) = {
  fonts = 字体 + fonts
  if body-font == auto { body-font = fonts.宋体 }
  if body-size == auto { body-size = 字号.小四 }
  let is-graduate = doctype == "master" or doctype == "doctor"
  if title == auto {
    title = if english-writing {
      "Acknowledgements"
    } else if doctype == "bachelor" {
      "致 谢"
    } else {
      "致　谢"
    }
  }
  if title-leading == auto {
    title-leading = preface-heading-leading
  }
  if title-above == auto {
    title-above = if is-graduate { preface-heading-above } else { 0pt }
  }
  if title-below == auto {
    title-below = if is-graduate { preface-heading-below } else { 0pt }
  }
  if leading == auto {
    leading = if doctype == "bachelor" { 2.4pt } else { preface-body-leading }
  }
  if spacing == auto {
    spacing = if doctype == "bachelor" { 0pt } else { preface-body-spacing }
  }

  if not anonymous {
    pagebreak(weak: true, to: if twoside { "odd" })
    [
      #set text(font: body-font, size: body-size)
      #set par(
        leading: leading,
        spacing: spacing,
        justify: true,
        first-line-indent: if doctype == "bachelor" { (amount: 26pt, all: true) } else { preface-body-first-line-indent },
      )

      // 覆盖正文阶段遗留的 heading show 规则，避免无编号一级标题被重复叠加段前距
      #show heading: it => {
        if it.level == 1 and it.numbering == none {
          preface-heading-style(
            it,
            fonts,
            leading: title-leading,
            above: 0pt,
            below: title-below,
          )
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
