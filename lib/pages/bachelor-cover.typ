#import "../utils/datetime-display.typ": datetime-year-month
#import "../utils/style.typ": 字号, 字体
#import "cover-utils.typ": info-row

// 本科生封面
#let bachelor-cover(
  anonymous: false,
  info: (:),
) = {
  info.submit-date = datetime-year-month(info.submit-date)

  let mask-value(body) = {
    if anonymous { "████████" } else { body }
  }

  v(2.3cm)
  image("../../template/figures/nwpulogo.png", width: 8cm)

  set text(size: 字号.小初, weight: "bold")
  
  [本科毕业设计（论文）]

  v(3.5cm)

  set text(size: 字号.三号, font: 字体.黑体)

  table(
    columns: (2cm, 10cm),
    rows: 1.2cm,
    ..info-row(text()[题 目], [#info.title]),
  )

  set text(size: 字号.四号, weight: "regular", font: 字体.宋体)

  table(
    columns: (2.2cm, 6cm),
    rows: 2.2cm,
    ..info-row([专业名称], info.major),
    ..info-row([学生姓名], mask-value(info.author)),
    ..info-row([指导教师], mask-value(info.supervisor.at(0))),
    ..info-row([毕业时间], info.submit-date),
  )
}
