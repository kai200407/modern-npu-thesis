#import "../utils/datetime-display.typ": (
  datetime-display, datetime-year-month, datetime-year-month-en,
)
#import "../utils/style.typ": 字体, 字号

// 研究生封面
// 包含：外封（表格形式）、内封（简洁居中）、英文封面、评阅人名单
#let master-cover(
  degree: "master",
  track: "academic",
  colored-cover: false,
  anonymous: false,
  info: (:),
) = {
  let stroke-width = 0.5pt
  let min-title-lines = 2
  let info-inset = (x: 0pt, bottom: 0.5pt)
  let meta-info-inset = (x: 0pt, bottom: 2pt)
  let defence-info-inset = (x: 0pt, bottom: 0pt)
  let defence-info-key-width = 110pt
  let defence-info-column-gutter = 2pt
  let defence-info-row-gutter = 12pt
  let anonymous-info-keys = (
    "student-id",
    "author",
    "author-en",
    "supervisor",
    "supervisor-en",
    "chairman",
    "reviewer",
  )
  // 对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 根据 min-title-lines 填充标题
  info.title = info.title + range(min-title-lines - info.title.len()).map(it => "　")

  // 2.4 处理 degree
  if info.degree == auto {
    if degree == "doctor" {
      info.degree = "工学博士"
    } else {
      info.degree = "工学硕士"
    }
  }
  
  // 3.  内置辅助函数
  let anonymous-text(key, body) = {
    if anonymous and (key in anonymous-info-keys) {
      "██████████"
    } else {
      body
    }
  }
  
  let defence-info-key(body) = {
    rect(
      inset: defence-info-inset,
      stroke: none,
      text(size: 字号.三号, weight: "bold", body),
    )
  }
  
  let defence-info-value(key, body, no-stroke: false) = {
    set align(center)
    rect(
      width: 100%,
      inset: defence-info-inset,
      stroke: if no-stroke { none } else { (bottom: stroke-width + black) },
      text(
        size: 字号.三号,
        bottom-edge: "descender",
        if anonymous and (key in anonymous-info-keys) {
          "█████"
        } else {
          body
        },
      ),
    )
  }
  
  // 名字等宽处理：仅对中文短姓名生效，避免与英文长姓名混排时被过度拉伸
  let pad-name(name, target-len) = {
    if target-len > 4 {
      name
    } else {
      let clusters = name.clusters()
      let current-len = clusters.len()
      if current-len >= target-len {
        name
      } else {
        // 计算需要插入的全角空格数
        let spaces-needed = target-len - current-len
        // 将空格均匀分布在字符之间
        let result = ()
        let gap-count = current-len - 1
        if gap-count == 0 {
          // 单字名，在后面加空格
          result.push(clusters.at(0))
          result.push("　" * spaces-needed)
        } else {
          // 计算每个间隔需要插入的空格数（使用 floor 实现整数除法）
          let base-spaces = calc.floor(spaces-needed / gap-count)
          let extra-spaces = calc.rem(spaces-needed, gap-count)
          for i in range(current-len) {
            result.push(clusters.at(i))
            if i < gap-count {
              let spaces = base-spaces + (if i < extra-spaces { 1 } else { 0 })
              result.push("　" * spaces)
            }
          }
        }
        result.join("")
      }
    }
  }
  
  
  // ========================================
  // 第一页 - 外封（表格形式）
  // ========================================
  
  let bg = none
  if colored-cover {
    let cover-image-path = if degree == "doctor" {
      "../../template/figures/博士论文封面.jpg"
    } else if track == "professional" {
      "../../template/figures/专硕论文封面.jpg"
    } else {
      "../../template/figures/学硕论文封面.jpg"
    }
    bg = image(cover-image-path, width: 100%, height: 100%)
  }
  set page(background: bg)
  
  // 设置外封页默认字体
  set text(size: 字号.五号)
  
  // 右上角元信息表格（学校代码、分类号、密级、学号）
  align(right)[
    #set text(font: 字体.黑体, size: 字号.五号, weight: "bold")
    #table(
      columns: (2.05cm, 2.4cm),
      rows: 0.55cm,
      stroke: (x: stroke-width, y: stroke-width),
      inset: (x: 8pt, y: 3pt),
      align: center,
      [学校代码], [#info.school-code],
      [分#h(0.5em)类#h(0.5em)号], [#info.class-no],
      [密　　级], [#info.secret-level],
      [学　　号], [#anonymous-text("student-id", info.student-id)],
    )
  ]
  
  // 题目区域（两行两列表格）
  v(21 * 10.5pt * 1.05)
  
  align(center)[
    #set text(font: 字体.黑体, size: 字号.二号, weight: "bold")
    #table(
      columns: (2.34cm, 12.13cm),
      rows: (1.45cm, 1.45cm),
      stroke: none,
      align: (center + bottom, center + bottom),
      // 第一行：题目 + 题目第一行
      [题目], table.cell(stroke: (bottom: stroke-width), [#info.title.at(0, default: "")]),
      // 第二行：空 + 题目第二行
      [], table.cell(stroke: (bottom: stroke-width), [#info.title.at(1, default: "")]),
    )
  ]
  
  v(2 * 10.5pt * 1.02)
  
  // 作者（一行两列表格，只保留第二列下框线）
  // 使用 context 测量作者姓名实际宽度，最小为 3.72cm
  context {
    let author-display = anonymous-text("author", info.author)
    let author-width = calc.max(
      3.72cm,
      measure(text(size: 字号.三号, weight: "bold", author-display)).width,
    )
    
    align(center)[
      #set text(size: 字号.三号, weight: "bold")
      #table(
        columns: (1.56cm, author-width),
        rows: 1.28cm,
        stroke: none,
        inset: (x: 0pt, y: 4pt),
        // 第一列：作者
        table.cell(align: center + bottom, [作者]),
        // 第二列：作者姓名（只有下框线）
        table.cell(align: center + bottom, stroke: (bottom: stroke-width), [#author-display]),
      )
    ]
  }
  
  v(3 * 10.5pt * 1.06)
  
  // 详细信息表格（四行两列）
  let major-row-label = if track == "professional" { "专 业 领 域" } else { "学 科 专 业" }
  
  align(center)[
    #set text(size: 字号.三号, weight: "bold")
    #table(
      columns: (3.59cm, 9cm),
      rows: (1cm, 1cm, 1cm, 1cm),
      stroke: none,
      inset: (x: 0pt, y: 4pt),
      // 第一行：学科专业
      table.cell(align: center + bottom, [#major-row-label]),
      table.cell(align: center + horizon, stroke: (bottom: stroke-width), [#info.major]),
      // 第二行：指导教师
      table.cell(align: center + bottom, [指 导 教 师]),
      table.cell(align: center + horizon, stroke: (bottom: stroke-width), [#anonymous-text(
        "supervisor",
        info.supervisor.intersperse(" ").sum(),
      )]),
      // 第三行：培养单位
      table.cell(align: center + bottom, [培 养 单 位]),
      table.cell(align: center + horizon, stroke: (bottom: stroke-width), [#info.department]),
      // 第四行：申请日期
      table.cell(align: center + bottom, [申 请 日 期]),
      table.cell(align: center + horizon, stroke: (bottom: stroke-width), [#datetime-year-month(info.submit-date)]),
    )
  ]
  
  // ========================================
  // 第二页 - 内封（简洁居中形式）
  // ========================================
  set page(background: none)
  pagebreak(weak: true, to: "odd")
  
  set align(center)
  
  v(6 * 10.5pt * 1.4) // 约 15pt
  
  // 校名
  text(size: 字号.三号)[
    西 北 工 业 大 学
  ]

  v(0mm)

  // 学位论文类型
  text(size: 字号.一号)[
    #if degree == "doctor" { "博 士 学 位 论 文" } else { "硕 士 学 位 论 文" }
  ]
  
  v(6 * 14pt * 1.5) // 约 126pt
  
  // 论文信息（简洁格式）
  set text(size: 字号.二号)
  
  align(center)[
    #table(
      columns: (2.34cm, 9.13cm),
      rows: (1.45cm, 1.45cm),
      stroke: none,
      inset: (x: 0pt, y: 4pt),
      align: (center + bottom, center + bottom),
      // 第一行：题目 + 题目第一行
      [题目：], table.cell(stroke: (bottom: stroke-width), [#info.title.at(0, default: "")]),
      // 第二行：空 + 题目第二行
      [], table.cell(stroke: (bottom: stroke-width), [#info.title.at(1, default: "")]),
    )
  ]
  
  let major-label = if track == "professional" { "专业领域" } else { "学科专业" }
  
  // 计算作者和指导教师名字的最大长度，用于等宽显示
  let author-name = info.author
  let supervisor-name = info.supervisor.at(0)
  let max-name-len = calc.max(author-name.clusters().len(), supervisor-name.clusters().len())
  let author-display-name = pad-name(author-name, max-name-len)
  let supervisor-display-name = pad-name(supervisor-name, max-name-len)
  
  
  v(5 * 10.5pt * 1.4) // 约 94pt
  
  // 其他信息
  set text(size: 字号.三号)
  
  context {
    let info-column-width = calc.max(
      5cm,
      measure(text(size: 字号.三号, info.major)).width,
      measure(text(size: 字号.三号, author-display-name)).width,
      measure(text(size: 字号.三号, supervisor-display-name)).width,
    )
    
    align(center)[
      #set text(size: 字号.三号)
      #table(
        columns: (3.59cm, info-column-width),
        rows: 1.2cm,
        stroke: none,
        inset: (x: 0pt, y: 4pt),
        // 第一行：学科专业
        table.cell(align: center + bottom, [#major-label:]),
        table.cell(align: center + bottom, stroke: (bottom: stroke-width), [#info.major]),
        // 第二行：作者
        table.cell(align: center + bottom, [作　　者:]),
        table.cell(align: center + bottom, stroke: (bottom: stroke-width), [#anonymous-text(
          "author",
          author-display-name,
        )]),
        // 第三行：指导教师
        table.cell(align: center + bottom, [指导教师:]),
        table.cell(align: center + bottom, stroke: (bottom: stroke-width), [#anonymous-text(
          "supervisor",
          supervisor-display-name,
        )]),
      )
    ]
  }
  
  v(2 * 10.5pt * 1.6) // 约 31pt
  
  // 日期
  text(size: 字号.三号, datetime-year-month(info.submit-date))
  
  // 中文标题页后插入空白页
  pagebreak(weak: true, to: "odd")
  
  // ========================================
  // 第三页 - 英文封面
  // ========================================

  set text(size: 字号.小四)
  set par(leading: 0.7em)
  
  v(5 * 14pt * 1.4) // 约 59pt
  
  // 标题
  set text(size: 字号.二号)
  align(center)[
    #text(weight: "bold")[Title: ]
    #text(size: 字号.三号, info.title-en.at(0, default: ""))
    #for line in info.title-en.slice(1) [
      #linebreak()
      #text(size: 字号.三号, line)
    ]
  ]
  
  v((if info.title-en.len() >= 2 { 2 } else { 3 }) * 14pt * 1.4)
  
  // 作者信息
  set text(size: 字号.小三)
  text(weight: "bold")[By]
  
  linebreak()
  
  text(anonymous-text("author-en", info.author-en))
  
  linebreak()
  
  // 中文学术职称到英文的映射
  let title-en-map = (
    "教授": "Professor",
    "副教授": "Associate Professor",
    "研究员": "Researcher",
    "讲师": "Lecturer",
  )
  // 获取导师英文职称，默认为 Professor
  let supervisor-title-en = title-en-map.at(info.supervisor.at(1, default: "教授"), default: "Professor")
  
  text(weight: "bold")[Under the Supervision of #supervisor-title-en]
  linebreak()
  text(anonymous-text("supervisor-en", { info.supervisor-en }))
  
  v(5 * 14pt * 1.4) // 约 78pt
  
  // 学位信息
  set text(size: 字号.小三)
  [A Dissertation Submitted to]
  linebreak()
  [Northwestern Polytechnical University]
  
  v(1 * 14pt * 1.4) // 约 20pt
  
  [In Partial Fulfillment of The Requirement]
  linebreak()
  [For The Degree of]
  linebreak()
  let degree-title = if degree == "doctor" { "Doctor of " } else { "Master of " }
  if degree == "doctor" {
    text(degree-title)
    text(weight: "bold", info.major-en)
  } else {
    text(degree-title + info.major-en)
  }
  
  v(4 * 14pt * 1.4) // 约 78pt
  
  // 地点和日期
  [Xi'an, P.R. China]
  linebreak()
  text(datetime-year-month-en(info.submit-date))
  
  // 英文标题页后插入空白页
  pagebreak(weak: true, to: "odd")
  
  // ========================================
  // 第四页 - 评阅人和答辩委员会名单
  // ========================================
  
  set text(size: 字号.小四)
  
  v(2 * 18pt * 1.2) // 约 26pt
  
  // 页面标题
  align(center, text(font: 字体.黑体, size: 字号.三号)[学位论文评阅人和答辩委员会名单])
  
  // 评阅人表格
  v(1 * 22pt * 1.2) // 约 26pt
  
  align(center)[
    #set text(size: 字号.小四)
    #text(font: 字体.黑体, size: 字号.四号)[学位论文评阅人名单]
    
    #v(-5pt)
    
    #table(
      columns: (3.71cm, 2.83cm, 8.73cm),
      stroke: none,
      inset: (x: 4pt, y: 8pt),
      align: center,
      [*姓名*], [*职称*], [*工作单位*],
      ..info.reviewers.map(r => ([#anonymous-text("reviewer", r.name)], [#r.title], [#r.unit])).flatten(),
    )
  ]
  
  // 答辩委员会表格
  v(3 * 22pt * 1.2) // 约 26pt
  
  // 处理答辩日期
  let defence-date-display = datetime-display(info.defence-committee.date)
  let defence-committee = info.defence-committee
  let defence-members = {
    let entries = ()
    if defence-committee.chairman != none {
      entries.push((role: "主席", ..defence-committee.chairman))
    }
    for m in defence-committee.members {
      entries.push((role: "委员", ..m))
    }
    if defence-committee.secretary != none {
      entries.push((role: "秘书", ..defence-committee.secretary))
    }
    entries
  }
  
  align(center)[
    #set text(size: 字号.小四)
    #text(font: 字体.黑体, size: 字号.四号)[答辩委员会名单]

    #v(-5pt)
    
    #table(
      columns: (3.76cm, 2.68cm, 2.25cm, 6.75cm),
      stroke: none,
      inset: (x: 4pt, y: 8pt),
      align: center,
      [*答辩日期*], table.cell(colspan: 3, [#defence-date-display]),
      [*答辩委员会*], [*姓名*], [*职称*], [*工作单位*],
      ..defence-members.map(m => ([*#m.role*], [#anonymous-text("reviewer", m.name)], [#m.title], [#m.unit])).flatten(),
    )
  ]
}
