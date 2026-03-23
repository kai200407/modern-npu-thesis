#import "../utils/style.typ": 字体, 字号

// 统一页眉组件
// content: 页眉显示的内容
// fonts: 字体配置
#let header-render(content, fonts: (:)) = {
  fonts = 字体 + fonts
  [
    // 重置段落设置，避免受外部影响
    #set par(leading: 0em, spacing: 0em)
    #set text(font: fonts.宋体, size: 字号.小五)
    #align(center)[#content]
    #v(0.5em)
    #line(length: 100%, stroke: 3pt + black)
    #v(0.4em)
    #line(length: 100%, stroke: 0.5pt + black)
  ]
}

// 研究生页眉设置（用于 doc.typ 全局设置）
// header-ascent 控制页面顶部到页眉内容底部的距离
// 页眉内容高度约为：文字(约9pt) + 0.5em间距 + 3pt线 + 0.6em间距 + 0.5pt线 ≈ 1.5em + 3.5pt
// 为达到正文距顶部约1.5cm的效果，需要减去页眉内容高度
#let graduate-header-config = (
  header-ascent: 1.5cm - 1.5em,
)
