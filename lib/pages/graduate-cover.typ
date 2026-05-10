#import "../utils/style.typ": 字体, 字号
#import "../utils/cover-utils.typ": (
  datetime-display, datetime-year-month, datetime-year-month-en, distribute, info-row, major-en-map, mask-value,
  title-en-map,
)

// 研究生封面
// 包含：外封（表格形式）、内封（简洁居中）、英文封面、评阅人名单
#let master-cover(
  degree: "master",
  track: "academic",
  colored-cover: false,
  anonymous: false,
  info: (:),
) = {
  let anonymous-info-keys = (
    "student-id",
    "author",
    "author-en",
    "supervisor",
    "supervisor-en",
    "chairman",
    "reviewer",
  )
  // 内置辅助函数
  let anonymous-text(key, body) = {
    mask-value(body, anonymous: anonymous and (key in anonymous-info-keys))
  }

  // ========================================
  // 第一页 - 外封（表格形式）
  // ========================================

  let bg = none
  if colored-cover {
    let cover-image-path = if degree == "doctor" {
      "../assets/doctor-cover.jpg"
    } else if track == "professional" {
      "../assets/professional-cover.jpg"
    } else {
      "../assets/academic-cover.jpg"
    }
    bg = image(cover-image-path, width: 100%, height: 100%)
  }
  set page(background: bg)

  // 右上角元信息表格（学校代码、分类号、密级、学号）
  align(right)[
    #set text(font: 字体.黑体, size: 字号.五号, weight: "bold")
    #table(
      columns: (2.05cm, 2.4cm),
      rows: 0.55cm,
      stroke: 0.5pt,
      inset: (x: 8pt, y: 3pt),
      [#distribute[学校代码]], [#info.school-code],
      [#distribute[分类号]], [#info.class-no],
      [#distribute[密级]], [#info.secret-level],
      [#distribute[学号]], [#anonymous-text("student-id", info.student-id)],
    )
  ]

  v(231pt)

  text(font: 字体.黑体, size: 字号.二号, weight: "bold")[
    #table(
      columns: (2.34cm, 12.13cm),
      rows: (1.45cm, 1.45cm),
      ..info-row([题目], [#info.title.at(0, default: "")]),
      ..info-row([], [#info.title.at(1, default: "")]),
    )
  ]

  v(21pt)

  // 作者（一行两列表格，只保留第二列下框线）
  context {
    let author-display = anonymous-text("author", info.author)
    let author-width = calc.max(
      3.72cm,
      measure(text(size: 字号.三号, weight: "bold", author-display)).width,
    )
    set text(size: 字号.三号, weight: "bold")
    table(
      columns: (1.56cm, author-width),
      rows: 1.28cm,
      ..info-row([作者], [#author-display]),
    )
  }

  v(33pt)

  let major-row-label = if track == "professional" { "专业领域" } else { "学科专业" }

  text(size: 字号.三号, weight: "bold")[
    #table(
      columns: (3.59cm, 9cm),
      rows: (1cm,),
      ..info-row(distribute(width: 5.5em, major-row-label), info.major),
      ..info-row([#distribute(width: 5.5em)[指导教师]], anonymous-text(
        "supervisor",
        info.supervisor.intersperse(" ").sum(),
      )),
      ..info-row([#distribute(width: 5.5em)[培养单位]], info.department),
      ..info-row([#distribute(width: 5.5em)[申请日期]], datetime-year-month(info.submit-date)),
    )
  ]

  // ========================================
  // 第二页 - 内封（简洁居中形式）
  // ========================================
  set page(background: none)
  pagebreak(weak: true, to: "odd")
  v(88pt)
  text(size: 字号.三号)[
    #distribute(width: 8.5em)[西北工业大学]
  ]
  v(10pt)
  let degree-label = if degree == "doctor" { "博士学位论文" } else { "硕士学位论文" }
  text(size: 字号.一号)[
    #distribute(width: 8.5em)[#degree-label]
  ]
  v(140pt)
  text(size: 字号.二号)[
    #table(
      columns: (2.34cm, 9.13cm),
      rows: (1.45cm, 1.45cm),
      ..info-row([题目：], [#info.title.at(0, default: "")]),
      ..info-row([], [#info.title.at(1, default: "")]),
    )
  ]

  let major-label = if track == "professional" { "专业领域" } else { "学科专业" }

  let author-name = info.author
  let supervisor-name = info.supervisor.at(0)
  let max-name-len = calc.max(author-name.clusters().len(), supervisor-name.clusters().len())
  let name-width = max-name-len * 1em

  v(94pt)

  text(size: 字号.三号)[
    #context {
      let info-column-width = calc.max(
        5cm,
        measure(text(size: 字号.三号, info.major)).width,
      )

      table(
        columns: (3.59cm, info-column-width),
        rows: 1.2cm,
        ..info-row([#major-label:], info.major),
        ..info-row([#distribute[作者]:], anonymous-text("author", distribute(width: name-width, author-name))),
        ..info-row([#distribute[指导教师]:], anonymous-text("supervisor", distribute(width: name-width, supervisor-name))),
      )
    }

    #v(35pt)
    #text(datetime-year-month(info.submit-date))
  ]

  pagebreak(weak: true, to: "odd")

  // ========================================
  // 第三页 - 英文封面
  // ========================================
  // 自动填充英文学科名（当 major-en 为默认值且 major 在映射表中时）
  if info.major-en == "XX" and info.major in major-en-map {
    info.major-en = major-en-map.at(info.major)
  }
  let supervisor-title-en = title-en-map.at(info.supervisor.at(1, default: "教授"), default: "Professor")
  let degree-title = if degree == "doctor" { "Doctor of " } else { "Master of " }

  v(95pt)

  text(size: 字号.二号, weight: "bold")[Title: ]

  text(size: 字号.三号)[
    #text(info.title-en)
    #v(65pt)
  ]

  text(size: 字号.小三)[
    #text(weight: "bold")[By]
    #linebreak()
    #text(anonymous-text("author-en", info.author-en))
    #linebreak()
    #text(weight: "bold")[Under the Supervision of #supervisor-title-en]
    #linebreak()
    #text(anonymous-text("supervisor-en", { info.supervisor-en }))
    #v(100pt)
    A Dissertation Submitted to
    #linebreak()
    Northwestern Polytechnical University
    #v(25pt)
    In Partial Fulfillment of The Requirement
    #linebreak()
    For The Degree of
    #linebreak()
    #if degree == "doctor" {
      text(degree-title)
      text(weight: "bold", info.major-en)
    } else {
      text(degree-title)
      text(info.major-en)
    }
    #v(75pt)
    #text(font: "Times New Roman")[Xi'an, P. R. China]
    #linebreak()
    #text(datetime-year-month-en(info.submit-date))
  ]

  pagebreak(weak: true, to: "odd")

  // ========================================
  // 第四页 - 评阅人和答辩委员会名单
  // ========================================
  v(50pt)
  text(font: 字体.黑体, size: 字号.三号)[学位论文评阅人和答辩委员会名单]
  v(40pt)

  text(font: 字体.黑体, size: 字号.四号)[学位论文评阅人名单]
  table(
    columns: (3.71cm, 2.83cm, 8.73cm),
    inset: (x: 4pt, y: 8pt),
    [*姓名*], [*职称*], [*工作单位*],
    ..info.reviewers.map(r => ([#anonymous-text("reviewer", r.name)], [#r.title], [#r.unit])).flatten(),
  )
  v(79pt)

  let defence-date-display = datetime-display(info.defence-committee.date)
  let defence-committee = info.defence-committee
  let defence-members = {
    let entries = ()
    entries.push((role: "主席", ..defence-committee.chairman))
    for m in defence-committee.members {
      entries.push((role: "委员", ..m))
    }
    entries.push((role: "秘书", ..defence-committee.secretary))
    entries
  }

  v(10pt)

  text(font: 字体.黑体, size: 字号.四号)[答辩委员会名单]
  table(
    columns: (3.76cm, 2.68cm, 2.25cm, 6.75cm),
    inset: (x: 4pt, y: 8pt),
    [*答辩日期*], table.cell(colspan: 3, [#defence-date-display]),
    [*答辩委员会*], [*姓名*], [*职称*], [*工作单位*],
    ..defence-members.map(m => ([*#m.role*], [#anonymous-text("reviewer", m.name)], [#m.title], [#m.unit])).flatten(),
  )
}
