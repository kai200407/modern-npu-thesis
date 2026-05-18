<div align="center">

**西北工业大学本硕博论文 Typst 模板**

***modern-npu-thesis***

[![CI](https://github.com/1195343015/modern-npu-thesis/actions/workflows/test.yml/badge.svg)](https://github.com/1195343015/modern-npu-thesis/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

> 如果你想使用 LaTeX 模板，请移步 [nwputhesis](https://github.com/1195343015/nwputhesis)。

## 优势与特性

- **语法简洁**：上手难度与 Markdown 相当，无需记忆繁琐的命令。
- **极速编译**：采用增量编译，长文档不影响编译速度。
- **环境搭建简单**：即开即用，无需配置数G的开发环境。
- **生态蓬勃发展**：国内多所高校已有 Typst 论文模板，详见 [cn-university-typst-thesis-templates](https://github.com/1195343015/cn-university-typst-thesis-templates)。

### 使用方法

1. Fork 本仓库到自己的账号下，然后克隆 Fork 后的仓库。（建议优先通过 Fork 使用，方便后续同步模板更新。）
2. 使用 VS Code 打开项目，并安装 [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 插件。
3. 打开项目后：
   修改 [template/graduate.typ](template/graduate.typ) 可编辑研究生论文，
   修改 [template/bachelor.typ](template/bachelor.typ) 可编辑本科生论文。

仓库已提供工作区配置 [.vscode/settings.json](.vscode/settings.json)，会为 Tinymist 默认追加 `--font-path fonts`，因此在不同系统下都会优先使用仓库内自带的 Windows 字体文件。

### 模板更新迁移指南

如果你已经基于本仓库开始写论文，后续想同步模板更新，通常只需要：

1. 保留你自己的 [template](template) 目录。
2. 用新版本仓库中的其他文件替换当前项目内对应文件。

由于目前模板仍在建设初期，使用方法可能会有变化。如果替换后编译报错，可查阅 [CHANGELOG.md](CHANGELOG.md) 了解最新变动，或参照新版本中的 `graduate.typ` / `bachelor.typ` 进行相应修改。

## 交流群

QQ 交流群：

<img src="template/figures/QQ交流群.jpg" width="200">

### 依赖包

本模板依赖以下 Typst 包，具体用法有疑惑可直接查阅相关文档：

- [`gb7714-bilingual`](https://typst.app/universe/package/gb7714-bilingual) `基于 Github main 分支的修改版本` — GB/T 7714 双语参考文献格式
- [`algorithmic`](https://typst.app/universe/package/algorithmic) `1.0.7` — 伪代码/算法排版
- [`cap-able`](https://typst.app/universe/package/cap-able) `Github dev分支` — 图/表
- [`pointless-size`](https://typst.app/universe/package/pointless-size) `0.1.2` — 中文字号

参考文献方面，模板针对西北工业大学本科、研究生论文格式要求做了特殊调整，因此。

> 本模板基于 [modern-nju-thesis](https://github.com/nju-lug/modern-nju-thesis) 开发，设计过程中还参考了 [pkuthss-typst](https://github.com/pku-typst/pkuthss-typst) 的实现。

## License

MIT License

Copyright (c) 2024 OrangeX4

Copyright (c) 2026 Jiayi Yan
