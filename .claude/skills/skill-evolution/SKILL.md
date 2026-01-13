---
name: skill-evolution
description: Skill 全生命周期管理系统。支持创建、进化、修正、验证、无极进化。触发词包括"创建 skill"、"生成 skill"、"进化 skill"、"积累知识"、"修正 skill"、"验证 skill"、"无极进化"、"无级进化"、"主动优化 skill"、"skill 分类"、"skill 配置"。
---

# Skill 全生命周期管理系统

支持 Skill 的创建、进化、修正、验证全流程管理。采用提示模式，由用户决定是否执行。

## 快速导航

| 功能 | 触发词 | 说明 |
|-----|-------|------|
| [创建 Skill](#创建新-skill) | "创建 skill"、"生成 skill" | 从对话/文件/描述创建新 skill |
| [知识积累](#自我进化积累知识) | "进化 skill"、"积累知识" | 将新发现的知识加入 skill |
| [错误修正](#自我纠正修正错误) | "修正 skill" | 修正 skill 中的错误内容 |
| [准确性验证](#自我验证检查准确性) | "验证 skill" | 检查 skill 内容是否仍然有效 |
| [无极进化](#无极进化) | "无极进化"、"无级进化"、"主动优化" | 主动搜索最新知识优化 skill |
| [Skill 合并](#skill-合并) | "合并 skill" | 合并功能重叠的 skill |
| [分类管理](#用户自定义分类) | "skill 分类" | 查看/创建/删除分类 |
| [配置修改](#配置管理) | "skill 配置" | 修改进化系统配置 |

---

## 核心能力

| 能力 | 说明 | 触发方式 |
|-----|------|---------|
| 创建 | 从对话/文件/描述创建新 skill | "创建 skill"、"生成 skill" |
| 进化 | 积累新知识到已有 skill | 检测到可复用模式时提示 |
| 修正 | 修正错误的 skill 内容 | skill 建议导致失败时提示 |
| 验证 | 检查 skill 是否仍然准确 | 手动触发或定期提示 |
| **无极进化** | 主动搜索最新知识优化 skill | "无极进化"、"主动优化 skill" |
| 合并 | 合并功能重叠的 skill | "合并 skill" |
| 管理 | 分类、配置、删除 | "skill 分类"、"skill 配置" |

## 管理范围（可配置）

```
全部 skill     → .claude/skills/*
特定领域       → .claude/skills/<domain>/*
项目专属知识   → .claude/skills/project-knowledge/
```

---

<!-- Added: 2026-01-13 | source: 合并 skill-generator | trigger: 用户请求 -->
## 创建新 Skill

从对话、文件或口头描述中提炼内容，创建新的 skill。

### 内容来源识别

按优先级判断内容来源：

| 优先级 | 来源 | 判断依据 |
|-------|------|---------|
| 1 | 指定文件 | 用户提供了文件路径 |
| 2 | 当前对话 | 对话中有可提炼的模式、指令、偏好 |
| 3 | 口头描述 | 用户直接描述 skill 功能 |

如来源不明确，询问：
> "从哪里生成 skill？A) 当前对话 B) 指定文件 C) 你来描述"

### Skill 模板结构

```markdown
---
name: <skill-name>
description: <清晰描述功能和触发时机，包含多种触发表述>
---

# <Skill 标题>

## 适用场景
<什么情况下使用>

## 执行流程
<具体步骤，编号列表>

## 示例
<输入输出示例>

## 注意事项
<边界条件、常见错误>
```

### description 编写要点

description 决定 skill 能否被自动触发，务必认真编写：

| 要点 | 说明 | 示例 |
|-----|------|------|
| 包含多种表述 | 中英文、同义词 | "review、代码审查、检查代码" |
| 明确触发时机 | "当用户...时使用" | "当用户请求审查代码时使用" |
| 具体而非模糊 | 避免泛泛描述 | ❌ "帮助处理代码" ✅ "审查代码质量" |
| 控制长度 | < 1024 字符 | 简洁但完整 |

### 创建流程

```
1. 识别内容来源
2. 提炼核心规则/流程
3. 确定 skill 名称（小写字母 + 连字符）
4. 填充模板结构
5. 写入 .claude/skills/<name>/SKILL.md
6. 确认完成
```

---

## 进化检测与提示

### 检测时机

| 场景 | 检测信号 | 提示内容 |
|-----|---------|---------|
| 解决了一个问题 | 多次尝试后成功 | "这个解决方案要积累到 skill 吗？" |
| 发现可复用模式 | 代码结构有通用性 | "这个模式可以抽象为 skill" |
| 学到新知识 | 查阅文档/搜索后解决 | "要把这个知识点记录下来吗？" |
| Skill 导致错误 | 按 skill 建议执行后失败 | "skill 内容可能有误，要修正吗？" |
| 会话即将结束 | 用户说"结束"或长时间无操作 | "本次会话学到了什么，要积累吗？" |

### 提示格式

当检测到进化机会时，使用以下格式提示：

```markdown
💡 **进化机会检测**

类型：[新知识 / 模式发现 / 问题解决 / 需要修正]
内容摘要：<简要描述>
建议目标：<目标 skill 或新建 skill>

要现在处理吗？(Y/N/稍后)
```

### 不打扰原则

- 同一会话中相似提示最多出现 1 次
- 用户拒绝后，同类型提示本次会话不再出现
- 专注编码时（连续工具调用）延迟提示

---

## 自我进化：积累知识

用户确认后执行以下流程：

### 步骤 1：确定目标

```
├─ 已有 skill → 追加内容
└─ 新分类 → 创建新 skill
```

询问用户：
> "要添加到哪个 skill？"
> - A) <已有 skill 列表>
> - B) 创建新 skill

### 步骤 2：格式化内容

```
├─ 提取核心知识点
├─ 添加示例代码（如有）
└─ 标注来源和日期
```

### 步骤 3：添加内容标记

```markdown
<!-- Added: YYYY-MM-DD | source: 来源描述 | trigger: 触发类型 -->
## 新增内容标题

内容正文...
```

### 步骤 4：写入文件

```bash
# 如果是更新已有 skill，先备份
cp .claude/skills/<name>/SKILL.md \
   .claude/skills/<name>/SKILL.md.bak.$(date +%Y%m%d-%H%M%S)

# 追加或写入新内容
```

### 步骤 5：确认完成

```markdown
✅ **知识已积累**

- 目标：`<skill-name>`
- 路径：`.claude/skills/<skill-name>/SKILL.md`
- 新增内容：<内容摘要>
```

---

## 自我纠正：修正错误

当 skill 建议导致错误时：

### 步骤 1：定位问题

```
├─ 找到导致错误的 skill 段落
└─ 分析错误原因
```

### 步骤 2：确认修正内容

向用户展示：
```markdown
**发现需要修正的内容**

Skill：`<skill-name>`
问题段落：
> <原内容摘要>

错误原因：<分析>

建议修正为：
> <新内容摘要>

确认修正？(Y/N)
```

### 步骤 3：执行修正

```bash
# 备份原文件
cp .claude/skills/<name>/SKILL.md \
   .claude/skills/<name>/SKILL.md.bak.$(date +%Y%m%d-%H%M%S)
```

### 步骤 4：添加修正标记

```markdown
<!-- Corrected: YYYY-MM-DD | was: 旧内容摘要 | reason: 修正原因 -->
## 修正后的内容

内容正文...
```

---

## 自我验证：检查准确性

### 触发方式

| 方式 | 说明 |
|-----|------|
| 手动触发 | 用户说"验证 skill"或"检查 skill 准确性" |
| 定期提示 | skill 超过 30 天未验证时提示 |
| 失败触发 | 同一 skill 多次导致问题时建议验证 |

### 验证流程

```
1. 选择验证范围
   ├─ 单个 skill
   ├─ 某个分类
   └─ 全部 skill

2. 逐项检查
   ├─ 代码示例是否能运行
   ├─ API/命令是否仍有效
   ├─ 描述是否与实际一致
   └─ 是否有过时内容

3. 生成报告
   ├─ ✅ 有效内容
   ├─ ⚠️ 需要更新
   └─ ❌ 已失效
```

### 验证报告格式

```markdown
## Skill 验证报告 (YYYY-MM-DD)

### 验证范围：<范围描述>

| 状态 | Skill | 内容 | 说明 |
|-----|-------|------|------|
| ✅ | skill-name | 某功能 | 正常工作 |
| ⚠️ | skill-name | 某功能 | 建议更新 |
| ❌ | skill-name | 某功能 | 已失效 |

### 建议操作
1. 更新 xxx
2. 删除 xxx
3. ...
```

### 验证后更新标记

```markdown
<!-- Validated: YYYY-MM-DD | status: passed/updated | by: user -->
```

---

<!-- Added: 2026-01-13 | source: 用户需求 | trigger: 功能扩展 -->
<!-- Corrected: 2026-01-13 | was: 只定义了新增操作 | reason: 用户反馈进化应包含多种操作类型 -->
## 无极进化

**与普通进化的区别：**
- 普通进化：从当前对话上下文提取知识
- 无极进化：主动搜索互联网和 GitHub，不依赖上下文

### 核心原则：进化 ≠ 只是新增

```
⚠️ 反模式：只做加法
├─ 不断新增章节
├─ 文件无限膨胀
├─ 旧内容无人维护
└─ 最终难以使用

✅ 正确模式：全面进化
├─ 新增（Add）     — 补充缺失的能力
├─ 更新（Update）  — 用新知识刷新旧内容
├─ 删除（Remove）  — 移除过时/冗余内容
├─ 重构（Refactor）— 优化结构和表述
├─ 合并（Merge）   — 整合重复内容
└─ 压缩（Compress）— 精简冗长表述
```

### 进化操作类型

| 操作 | 说明 | 触发条件 | 优先级 |
|-----|------|---------|-------|
| **更新** | 用最新知识刷新已有章节 | 发现更好的实践 | 高 |
| **删除** | 移除过时或错误内容 | 内容已失效 | 高 |
| **合并** | 整合分散的相似内容 | 发现内容重复 | 中 |
| **压缩** | 精简冗长表述 | 内容过于冗长 | 中 |
| **重构** | 优化结构和组织 | 结构不清晰 | 中 |
| **新增** | 添加全新能力 | 确实缺失且必要 | 低 |

**注意**：新增操作优先级最低，应优先考虑优化已有内容。

### 触发方式

用户说：
- "无极进化 <skill-name>"
- "无级进化 <skill-name>"
- "主动优化 <skill-name>"

### 执行流程

```
1. 选择目标 Skill
   └─ 用户指定或从列表选择

2. 问题诊断（重点：识别优化点）
   ├─ 读取当前 skill 内容
   ├─ 分析结构完整性
   ├─ 检查是否有过时内容      ← 删除候选
   ├─ 检查是否有重复内容      ← 合并候选
   ├─ 检查是否有冗长表述      ← 压缩候选
   ├─ 检查是否有可更新内容    ← 更新候选
   └─ 最后识别缺失能力        ← 新增候选

3. 知识搜索
   ├─ WebSearch：搜索相关领域最新实践
   │   - "<skill主题> best practices <当前年份>"
   │   - "<skill主题> latest updates"
   │   - "<skill主题> 最佳实践"
   │
   └─ GitHub 搜索：搜索相关开源项目
       - 搜索关键词：<skill主题> + 相关技术栈
       - 关注：README、配置文件、最佳实践文档
       - WebFetch 获取仓库内容

4. 分析与建议（分类呈现）
   ├─ 对比当前 skill 与最新知识
   ├─ 按操作类型分类建议
   │   ├─ 🔄 更新建议
   │   ├─ 🗑️ 删除建议
   │   ├─ 🔀 合并建议
   │   ├─ 📦 压缩建议
   │   └─ ➕ 新增建议（最后）
   └─ 生成优化建议报告

5. 用户确认
   └─ 展示建议，等待用户确认

6. 执行进化
   ├─ 备份当前版本
   ├─ 按优先级执行操作（更新/删除优先于新增）
   └─ 添加进化标记
```

### 知识搜索策略

| 搜索类型 | 工具 | 关键词模板 | 目的 |
|---------|------|-----------|------|
| 最新实践 | WebSearch | "<主题> best practices <年份>" | 获取业界最新标准 |
| 技术更新 | WebSearch | "<主题> new features updates" | 获取版本更新信息 |
| 开源项目 | WebSearch + WebFetch | "github <主题> awesome" | 获取优质开源实现 |
| 中文资源 | WebSearch | "<主题> 最佳实践 教程" | 获取中文社区经验 |

### 优化建议报告格式

```markdown
## 无极进化分析报告

### 目标 Skill：`<skill-name>`

### 当前状态诊断
- 结构完整性：✅/⚠️/❌
- 内容时效性：✅/⚠️/❌
- 覆盖全面性：✅/⚠️/❌
- 冗余程度：低/中/高

### 搜索到的最新知识
1. **[知识点1]** — 来源：<URL>
2. **[知识点2]** — 来源：<URL>
3. ...

### 优化建议（按优先级排序）

#### 🔄 更新建议（高优先级）
| # | 目标章节 | 更新内容 | 来源 |
|---|---------|---------|------|
| 1 | xxx 章节 | 用 xxx 替换 xxx | <来源> |

#### 🗑️ 删除建议（高优先级）
| # | 目标内容 | 删除原因 |
|---|---------|---------|
| 1 | xxx | 已过时/被新内容覆盖 |

#### 🔀 合并建议（中优先级）
| # | 合并对象 | 合并为 |
|---|---------|-------|
| 1 | A 章节 + B 章节 | 统一的 C 章节 |

#### 📦 压缩建议（中优先级）
| # | 目标章节 | 压缩方式 | 预估节省 |
|---|---------|---------|---------|
| 1 | xxx | 应用 TOON 格式 | ~30% |

#### ➕ 新增建议（低优先级）
| # | 新增内容 | 必要性说明 | 来源 |
|---|---------|-----------|------|
| 1 | xxx | 当前完全缺失且必要 | <来源> |

### 操作统计
- 更新: X 项
- 删除: X 项
- 合并: X 项
- 压缩: X 项
- 新增: X 项

确认执行？(Y/N/选择部分)
```

### 进化标记

```markdown
<!-- Evolved: YYYY-MM-DD | type: 无极进化 | sources: URL1, URL2 -->
```

### 注意事项

- 搜索结果需人工确认，避免引入错误信息
- 优先采用官方文档和高星 GitHub 项目
- 保留原有有效内容，增量优化
- 记录所有来源，便于追溯

---

<!-- Added: 2026-01-13 | source: 实际操作经验 | trigger: 进化 skill -->
## Skill 合并

当两个 skill 功能重叠时，可将其合并为一个更完整的 skill。

### 触发时机

- 发现两个 skill 有相似功能
- 用户主动请求合并
- 验证时发现冗余

### 合并流程

```
1. 功能对比分析
   ├─ 列出两个 skill 的功能点
   ├─ 标记重叠部分
   └─ 识别各自独有价值

2. 确定合并方向
   ├─ 选择保留哪个 skill（通常选功能更全的）
   └─ 确定要吸收的内容

3. 执行合并
   ├─ 备份目标 skill
   ├─ 将有价值内容添加到目标 skill
   ├─ 添加 Added 标记注明来源
   └─ 更新 description（如需要）

4. 清理
   ├─ 删除被合并的 skill
   └─ 更新 config.md（分类、验证记录）

5. 确认完成
   └─ 输出合并结果摘要
```

### 合并判断原则

| 情况 | 建议 |
|-----|------|
| A 包含 B 的全部功能 | B 合并到 A，删除 B |
| 功能互补，无明显主次 | 选择名称更通用的作为目标 |
| 重叠少，各有侧重 | 不合并，保持独立 |

---

## 用户自定义分类

### 查看分类

用户说："skill 分类" 或 "我有哪些 skill"

输出：
```markdown
## 当前 Skill 分类

| 分类 | 路径 | Skill 数量 | 最后更新 |
|-----|------|-----------|---------|
| code-review | .claude/skills/code-review/ | 1 | 2026-01-13 |
| frontend-daily | .claude/skills/frontend-daily/ | 1 | 2026-01-13 |
| ... | ... | ... | ... |
```

### 创建分类

用户说："创建一个 <分类名> 分类"

流程：
1. 确认分类名称（小写字母、连字符）
2. 创建目录 `.claude/skills/<分类名>/`
3. 创建基础 `SKILL.md` 模板
4. 更新配置文件

### 删除分类

用户说："删除 <分类名> 分类"

流程：
1. 确认分类存在
2. 二次确认（防止误删）
3. 备份后删除
4. 更新配置文件

---

## 配置管理

配置文件位置：`.claude/skills/skill-evolution/config.md`

### 查看配置

用户说："skill 配置"

### 修改配置

用户说："修改 skill 配置" 或直接说具体修改，如：
- "把验证提示改成 60 天"
- "忽略 frontend-daily skill"
- "只管理 patterns 分类"

### 可配置项

| 配置项 | 默认值 | 说明 |
|-------|-------|------|
| 管理范围 | 全部 skill | 全部/特定分类/项目知识 |
| 进化提示上限 | 3 次/会话 | 同一会话最多提示次数 |
| 验证周期 | 30 天 | 多久未验证时提示 |
| 忽略列表 | skill-evolution | 不进化的 skill |
| 备份保留数 | 5 | 保留最近几个备份 |

---

## Hooks 自动检测（可选）

Hooks 用于自动检测进化机会，仅提示不自动修改。

### 安装方式

```bash
# 将 hooks 配置合并到 .claude/settings.json
```

### Hooks 配置

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/skills/skill-evolution/hooks/detect-failure.sh"
        }]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [{
          "type": "command",
          "command": "bash .claude/skills/skill-evolution/hooks/session-summary.sh"
        }]
      }
    ]
  }
}
```

### Hook 说明

| Hook | 触发时机 | 作用 |
|-----|---------|------|
| detect-failure.sh | Bash 命令失败后 | 检测是否因 skill 导致，输出提示信号 |
| session-summary.sh | 会话结束时 | 统计可积累的知识，输出提示信号 |

---

## 快捷命令速查

| 命令 | 作用 |
|-----|------|
| "进化 skill" | 手动触发知识积累 |
| "积累知识" | 同上 |
| "修正 skill" | 手动触发修正流程 |
| "验证 skill" | 手动触发验证 |
| "skill 分类" | 查看/管理分类 |
| "skill 配置" | 查看/修改配置 |

---

## 质量准则

### 应该积累

- 通用、可复用的模式
- 常见问题的解决方案
- 经过验证的最佳实践
- 工具/框架的使用技巧
- 踩过的坑和规避方法

### 不应积累

- 项目特定的业务逻辑
- 未经验证的临时方案
- 重复已有的内容
- 不完整的示例
- 个人偏好（无客观理由）

---

## 文件结构

```
.claude/skills/skill-evolution/
├── SKILL.md          ← 本文件（主文档）
├── config.md         ← 用户配置
└── hooks/            ← 自动检测脚本（可选）
    ├── detect-failure.sh
    └── session-summary.sh
```

---


<!-- Merged: 2026-01-13 | merged: 评估与测试+效果度量+性能基准测试 | reason: 统一评估体系 -->
## 评估与度量

### 核心指标

| 类别 | 指标 | 目标值 | 说明 |
|-----|------|-------|------|
| 触发 | 触发率 | >80% | 触发次数/相关请求 |
| 质量 | 成功率 | >90% | 成功执行/触发次数 |
| 质量 | F1 Score | >0.85 | 准确率与召回率平衡 |
| 效率 | 响应时间 | <30s | 平均响应延迟 |
| 效率 | Token用量 | <2000 | 单次调用消耗 |

### 评估方法

| 方法 | 适用场景 | 说明 |
|-----|---------|------|
| A/B 测试 | 版本对比 | 不同版本效果对比 |
| 回归测试 | 每次更新 | 验证核心功能不退化 |
| LLM-as-Judge | 批量评估 | 模型自动评分 |
| Golden Dataset | 基准测试 | 精标数据集验证 |

### 回归测试清单

- [ ] 触发词正确触发
- [ ] 核心流程完整执行
- [ ] 示例代码可运行
- [ ] 输出格式符合预期

### 度量记录（config.md）

```markdown
| 月份 | 触发 | 成功 | 失败原因 |
|-----|-----|-----|---------|
| 01 | 25 | 23 | 示例过时 |
```

### 评估工具

| 工具 | 特点 |
|-----|------|
| DeepEval | 14+内置指标 |
| TruLens | RAG/Agent专用 |
| Langfuse | 自托管 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: getmaxim.ai -->
<!-- Compressed: 2026-01-13 | reason: 精简冗长内容 -->
## 协作工作流

### Skill 存储层级

| 层级 | 路径 | 用途 |
|-----|------|------|
| 个人 | `~/.claude/skills/` | 个人使用 |
| 项目 | `<project>/.claude/skills/` | 项目组共享 |
| 团队 | 共享仓库 | 跨项目复用 |

### 变更流程

```
提议 → 评审 → 测试 → 合并 → 监控
```

### Git 集成

```bash
# 分支：main → dev → feat/xxx
# 提交：skill(<name>): <变更描述>
git commit -m "skill(code-review): 添加 React 审查"
```

### 冲突解决

| 冲突类型 | 解决策略 |
|---------|---------|
| 新增章节 | 通常可合并 |
| 同一章节 | 讨论选最佳 |
| 删除 vs 修改 | 优先保留 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: anthropic.com, skywork.ai -->
## 进化策略进阶

### 渐进式进化

```
Level 1：基础版（快速上线）
├─ 核心功能
├─ 最小可用
└─ 快速验证

Level 2：增强版（迭代优化）
├─ 更多场景覆盖
├─ 示例补充
└─ 边界处理

Level 3：专家版（深度打磨）
├─ 高级技巧
├─ 最佳实践
└─ 工具集成
```

### 知识蒸馏

从冗长内容中提取精华：

```
原始知识（verbose）     →  蒸馏后（concise）
- 长篇解释              →  核心要点
- 多个示例              →  最佳示例
- 历史原因              →  当前最佳实践
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: getmaxim.ai, medium.com -->
<!-- Merged: 2026-01-13 | merged: RACE 框架 | reason: 功能相似，统一管理 -->
## 结构化框架

标准化的 Skill 结构，确保内容完整且便于分享。

### 5P 要素（推荐）

| 要素 | 作用 | 示例 |
|-----|------|------|
| **Role** | AI 扮演的角色 | "你是资深前端工程师" |
| **Goal** | 要达成的结果 | "审查代码并发现问题" |
| **Context** | 背景信息 | "React 项目，使用 TypeScript" |
| **Format** | 输出格式 | "Markdown 表格，按严重程度排序" |
| **Constraints** | 边界限制 | "只关注安全和性能" |

### RACE 框架（简化版，便于分享）

| 元素 | 说明 | 对应 5P |
|-----|------|--------|
| **R**ole | AI 角色 | Role |
| **A**ction | 执行动作 | Goal |
| **C**ontext | 背景约束 | Context + Constraints |
| **E**xpectation | 期望输出 | Format |

### 5P 检查清单

- [ ] Role：角色明确？专业领域清晰？
- [ ] Goal：目标具体可衡量？
- [ ] Context：背景充足？适用场景清楚？
- [ ] Format：输出格式明确？有示例？
- [ ] Constraints：边界完整？有负面约束？

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: generativeai.pub, github.com -->
## 跨平台兼容

让 Skill 在 Claude Code、Cursor、VS Code 等工具间复用。

### Agent Skills 开放标准

2025 年 Anthropic 发布 Agent Skills 开放标准，主要参与者：

| 平台 | 机制名称 | 存储位置 |
|-----|---------|---------|
| Claude Code | Skills | `.claude/skills/` |
| Cursor | Rules + Commands | `.cursor/rules/` 或 `.cursorrules` |
| VS Code (Copilot) | Instructions | `.github/copilot-instructions.md` |
| Windsurf | Rules | `.windsurfrules` |

### 跨平台复用策略

```
推荐存储结构（Claude Code 优先）：

.claude/
├── skills/
│   ├── code-review/
│   │   └── SKILL.md
│   └── ...
└── commands/          ← Cursor 可识别此目录

.cursor/
└── rules/
    └── code-review.mdc   ← 可从 skills 同步
```

**关键发现**：Cursor 可以识别 `.claude/commands/` 目录，但 Claude Code 不识别 `.cursor/` 目录。因此建议以 Claude Code 结构为主。

### 格式转换

从 Claude Skill 转换为 Cursor Rule：

```markdown
# Claude Skill 格式
---
name: code-review
description: 审查代码
---
# 内容...

# 转换为 Cursor Rule (.mdc 格式)
---
description: 审查代码
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---
# 内容...
```

### 同步脚本示例

```bash
#!/bin/bash
# sync-skills.sh - 将 Claude Skills 同步到 Cursor Rules

SKILLS_DIR=".claude/skills"
CURSOR_DIR=".cursor/rules"

mkdir -p "$CURSOR_DIR"

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    if [ -f "$skill_file" ]; then
        # 提取 description
        desc=$(grep "^description:" "$skill_file" | sed 's/description: //')

        # 创建 Cursor rule
        {
            echo "---"
            echo "description: $desc"
            echo "alwaysApply: false"
            echo "---"
            # 跳过 YAML frontmatter，复制内容
            sed '1,/^---$/d' "$skill_file" | sed '1,/^---$/d'
        } > "$CURSOR_DIR/$skill_name.mdc"

        echo "✅ Synced: $skill_name"
    fi
done
```

### 平台差异注意

| 差异点 | Claude Code | Cursor |
|-------|-------------|--------|
| 触发机制 | 语义匹配 description | glob 匹配 + alwaysApply |
| 工具调用 | 丰富的内置工具 | 有限的工具支持 |
| 上下文 | 完整对话历史 | 当前文件为主 |
| 手动触发 | `/skill-name` | `@rules` 引用 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: n8n.io, getmaxim.ai -->
## 安全与合规

Skill 的安全管理、审计和权限控制。

### 安全检查清单

创建或审核 Skill 时检查：

| 检查项 | 风险等级 | 说明 |
|-------|---------|------|
| 敏感信息 | 🔴 高 | Skill 中不应包含密钥、token、密码 |
| 命令注入 | 🔴 高 | Bash 命令是否有用户输入拼接风险 |
| 路径遍历 | 🟡 中 | 文件路径是否可能被操控 |
| 权限范围 | 🟡 中 | Skill 是否请求了过多权限 |
| 外部依赖 | 🟢 低 | 是否依赖外部 URL/API |

### 敏感信息保护

```markdown
# ❌ 错误示例
API_KEY=sk-xxx-your-key-here
curl -H "Authorization: Bearer $API_KEY" ...

# ✅ 正确示例
使用环境变量：$API_KEY 或 ${OPENAI_API_KEY}
```

**自动检测规则**：

```bash
# 检测 Skill 中的敏感信息
grep -rE "(api_key|apikey|secret|password|token|bearer)\s*[:=]" .claude/skills/
```

### 审计日志

记录 Skill 的重要变更：

```markdown
<!-- 在 config.md 中维护 -->
## 审计日志

| 时间 | 操作 | Skill | 操作者 | 说明 |
|-----|------|-------|-------|------|
| 2026-01-13 | 创建 | code-review | user | 初始版本 |
| 2026-01-13 | 进化 | code-review | system | 无极进化 |
| 2026-01-13 | 修正 | frontend-daily | user | 修复 RSS 源 |
```

### 权限控制模型

```
Skill 权限分级：

Level 0 - 只读
├─ 只能读取文件
└─ 不能执行命令

Level 1 - 受限执行
├─ 可执行白名单命令
├─ 不能访问网络
└─ 不能修改系统文件

Level 2 - 标准执行
├─ 可执行大多数命令
├─ 可访问网络
└─ 受沙箱保护

Level 3 - 完全信任
├─ 可执行任意命令
└─ 仅用于用户自己编写的 Skill
```

### Human-in-the-Loop (HITL)

对高风险操作保持人工审核：

```markdown
## HITL 配置

### 需要人工确认的操作
- 删除文件或目录
- 执行破坏性 git 命令（force push, hard reset）
- 修改配置文件
- 访问生产环境

### 升级规则
- 连续 3 次相似操作失败 → 请求人工介入
- 操作耗时超过 5 分钟 → 发送进度通知
- 检测到异常模式 → 暂停并报告

### 超时处理
- 等待人工确认最长 10 分钟
- 超时后自动取消操作
- 记录超时事件
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: medium.com, github.com/cline -->
<!-- Merged: 2026-01-13 | merged: Agentic Memory 模式 | reason: 消除冗余 -->
## Memory Bank 模式

实现跨会话的知识持久化，将知识存储在 context 外按需加载。

### 核心概念

```
传统模式：所有 Skill 加载到 context → 容易溢出
Memory Bank：只加载相关内容 → 高效利用 context

.claude/skills/ (外部存储) ──按需读取──→ Context Window
```

### Memory Bank 架构

```
.claude/
├── memory/                    ← Memory Bank 根目录
│   ├── project-context.md     ← 项目级上下文
│   ├── session-history/       ← 会话历史摘要
│   │   ├── 2026-01-13.md
│   │   └── ...
│   ├── decisions/             ← 架构决策记录
│   │   ├── adr-001-auth.md
│   │   └── ...
│   └── learned/               ← 学习到的知识
│       ├── bugs-fixed.md
│       └── patterns.md
└── skills/                    ← Skill 目录（已有）
```

### 项目上下文模板

```markdown
# Project Context

## 项目概述
- 名称：
- 类型：[Web App / CLI / Library / ...]
- 技术栈：

## 架构决策
- 状态管理：
- 路由方案：
- API 风格：

## 代码规范
- 命名约定：
- 文件组织：
- 测试要求：

## 常见问题
- 问题 1：解决方案
- 问题 2：解决方案

## 最近工作
<!-- 由系统自动更新 -->
- [日期] 完成了 xxx
- [日期] 修复了 xxx
```

### 会话摘要机制

每次会话结束时自动生成摘要：

```markdown
# 会话摘要 - 2026-01-13

## 完成的任务
- 实现了用户认证功能
- 修复了 3 个 TypeScript 类型错误

## 学到的知识
- React 19 的 use() hook 用法
- Zod schema 与 TypeScript 类型推断

## 遗留问题
- [ ] 需要添加单元测试
- [ ] 性能优化待处理

## 关键文件变更
- src/auth/login.tsx (新增)
- src/types/user.ts (修改)
```

### 上下文加载策略

```
会话开始时：
1. 读取 project-context.md（总是加载）
2. 读取最近 3 个会话摘要（按需）
3. 根据用户请求加载相关 decisions/learned

会话进行中：
4. 检测到相关话题 → 加载对应记忆
5. 学到新知识 → 提示保存到 learned/

会话结束时：
6. 生成会话摘要
7. 更新 project-context.md（如有重要变更）
```

### 与 Skill 进化的集成

```markdown
## Memory → Skill 进化路径

1. 知识首先记录到 Memory Bank
   └─ .claude/memory/learned/patterns.md

2. 当某个模式被多次使用（≥3次）
   └─ 提示：「这个模式出现多次，要创建 Skill 吗？」

3. 用户确认后，从 Memory 提炼为 Skill
   └─ .claude/skills/<new-skill>/SKILL.md

4. 原 Memory 记录标记为「已提炼」
   └─ <!-- Promoted to skill: <skill-name> -->
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: brainyboss.ai, hyscaler.com -->
## 4P Ladder 进阶路径

从简单 Prompt 到自主 Agent 的演进模型。

### 4P 阶梯概览

```
Level 4: Proactive Agents（主动代理）
         ↑ 自主执行、人工监督
Level 3: Plug-ins（插件）
         ↑ 连接工具和数据
Level 2: Playbooks（剧本）
         ↑ 可复用工作流
Level 1: Prompts（提示词）
         ↑ 基础交互
```

### 各层级详解

#### Level 1: Prompts（提示词）

```markdown
特征：
- 单次交互
- 手动触发
- 无状态

示例：
"帮我写一个 React 组件"

对应 Skill 类型：
- 简单的代码生成模板
- 单一任务指令
```

#### Level 2: Playbooks（剧本）

```markdown
特征：
- 多步骤流程
- 可复用
- 有明确的输入输出

示例：
"代码审查流程"
1. 读取 PR 描述
2. 分析代码变更
3. 检查各维度
4. 生成报告

对应 Skill 类型：
- 带流程的完整 Skill
- 包含检查清单和输出模板
```

#### Level 3: Plug-ins（插件）

```markdown
特征：
- 连接外部工具
- 数据集成
- 有安全边界

示例：
"集成 GitHub API 的 PR 审查"
- 自动获取 PR 信息
- 调用 lint/test 工具
- 发布评论到 PR

对应 Skill 类型：
- 包含工具调用的 Skill
- 需要权限配置
- 有错误处理逻辑
```

#### Level 4: Proactive Agents（主动代理）

```markdown
特征：
- 自主决策
- 持续运行
- 人工监督

示例：
"自动代码审查机器人"
- 监听 PR 创建事件
- 自动执行审查
- 根据严重程度决定是否阻塞
- 异常时通知人工

对应 Skill 类型：
- Agent 配置 + 多个 Skill 组合
- 需要 HITL 机制
- 需要监控和日志
```

### Skill 成熟度评估

评估你的 Skill 处于哪个层级：

| 层级 | 检查项 | 达标标准 |
|-----|-------|---------|
| L1 | 基础功能 | 能完成单一任务 |
| L2 | 流程完整 | 有明确步骤、可复用、有模板 |
| L3 | 工具集成 | 调用外部工具、处理错误、有权限控制 |
| L4 | 自主运行 | 事件驱动、自主决策、人工监督 |

### 升级路径建议

```
L1 → L2：添加流程
├─ 将单次操作扩展为多步骤
├─ 添加输入验证和输出模板
└─ 编写使用示例

L2 → L3：添加集成
├─ 识别可自动化的手动步骤
├─ 集成相关工具（git, npm, API）
├─ 添加错误处理和重试逻辑
└─ 配置权限边界

L3 → L4：添加自主性
├─ 定义触发事件（webhook, 定时）
├─ 设计决策逻辑
├─ 实现 HITL 机制
└─ 建立监控和告警
```

### 实际案例：code-review 的进化

```
L1 阶段：
"检查这段代码有没有问题"

L2 阶段：
完整的审查流程 + 检查清单 + 报告模板

L3 阶段（当前）：
+ 集成 ESLint/TypeScript 检查
+ 调用 git diff 获取变更
+ 格式化输出审查结果

L4 阶段（目标）：
+ GitHub webhook 触发
+ 自动评论到 PR
+ 根据问题严重程度阻塞合并
+ 异常情况通知维护者
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: aws.com, langwatch.ai, towardsdatascience.com -->
## DSPy 自动优化

将 Skill 优化从手工调试转向算法化优化。

### DSPy 是什么

DSPy 是一个用于算法化优化 LLM Prompt 的框架，核心理念：

```
传统方式：手工编写 Prompt → 测试 → 调整 → 重复
DSPy 方式：定义目标 + 指标 → 自动优化 → 验证结果
```

### 与 Skill 的关系

```
Skill 定义了「做什么」和「怎么做」
DSPy 自动优化「怎么表达」才能效果最好
```

### DSPy 核心概念

| 概念 | 说明 | 类比 Skill |
|-----|------|-----------|
| **Signature** | 定义输入输出的结构 | Skill 的 Format 部分 |
| **Module** | 封装 LLM 调用逻辑 | Skill 的 Execution 部分 |
| **Optimizer** | 自动优化 Prompt | 无极进化的自动化版本 |
| **Metric** | 评估效果的函数 | Skill 效果度量 |

### MIPROv2 优化器工作流程

```
1. Bootstrap（引导）
   └─ 从训练数据中提取高分示例

2. Propose（提议）
   └─ 分析模式，生成多个候选 Prompt

3. Search（搜索）
   └─ 贝叶斯搜索找到最优组合

4. Validate（验证）
   └─ 在验证集上确认效果
```

### Skill 优化实践

将 DSPy 思想应用到 Skill 优化：

```python
# 概念示例（非实际代码）

# 1. 定义 Skill 签名
class CodeReviewSignature:
    input: str   # 代码片段
    output: str  # 审查报告

# 2. 定义评估指标
def review_quality_metric(prediction, reference):
    # 检查是否发现了关键问题
    # 检查报告格式是否正确
    # 检查建议是否可操作
    return score

# 3. 准备训练数据
examples = [
    {"input": code1, "output": review1},
    {"input": code2, "output": review2},
    ...
]

# 4. 运行优化
optimizer = MIPROv2(metric=review_quality_metric)
optimized_prompt = optimizer.compile(
    CodeReviewSignature,
    trainset=examples
)
```

### 手动应用 DSPy 原则

即使不使用 DSPy 框架，也可以借鉴其原则：

| 原则 | 手动实践 |
|-----|---------|
| 定义清晰的输入输出 | 使用 5P 框架明确 Format |
| 收集高质量示例 | 记录成功的执行案例 |
| 建立评估指标 | 定义 Skill 成功的标准 |
| 迭代优化 | 根据失败案例调整 Prompt |
| A/B 测试 | 对比不同版本的效果 |

### 自动优化工具链

```
准备阶段：
├─ 收集 Skill 执行日志
├─ 标注成功/失败案例
└─ 定义评估指标

优化阶段：
├─ 使用 DSPy/LangWatch 运行优化
├─ 生成候选 Prompt 变体
└─ 自动评估和排序

部署阶段：
├─ 选择最优变体
├─ 更新 Skill 内容
└─ 添加进化标记
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: towardsai.net, talkk.ai, medium.com -->
## Skill 组合与编排

构建多 Skill 协作的复杂系统。

### 为什么需要 Skill 组合

```
单一 Skill：
└─ 完成单一任务，边界清晰

组合 Skill：
└─ 多个 Skill 协作完成复杂任务
   ├─ code-review + test-generator = 完整质量保证
   ├─ brainstorming + planning + implementation = 端到端开发
   └─ research + analysis + report = 深度调研
```

### 组合模式

#### 1. 顺序组合（Pipeline）

```
Skill A → Skill B → Skill C → 最终结果

示例：代码生成流水线
需求分析 → 架构设计 → 代码实现 → 代码审查 → 测试生成
```

#### 2. 并行组合（Parallel）

```
        ┌→ Skill A ─┐
输入 ───┼→ Skill B ─┼→ 合并 → 输出
        └→ Skill C ─┘

示例：多维度代码审查
        ┌→ 安全审查 ─┐
代码 ───┼→ 性能审查 ─┼→ 综合报告
        └→ 风格审查 ─┘
```

#### 3. 层级组合（Hierarchical）

```
主 Skill（协调者）
├─ 子 Skill A（专家）
├─ 子 Skill B（专家）
└─ 子 Skill C（专家）

示例：项目规划
项目规划 Skill（主）
├─ 需求分析 Skill
├─ 技术选型 Skill
└─ 任务分解 Skill
```

#### 4. 条件组合（Conditional）

```
       ┌─ 条件 A → Skill A
输入 ──┼─ 条件 B → Skill B
       └─ 条件 C → Skill C

示例：错误处理路由
       ┌─ 类型错误 → TypeScript 修复 Skill
错误 ──┼─ 运行时错误 → 调试 Skill
       └─ 性能问题 → 优化 Skill
```

### 依赖管理

定义 Skill 之间的依赖关系：

```yaml
# skill-manifest.yaml（概念示例）

name: full-code-review
version: 1.0.0
dependencies:
  - skill: code-review
    version: ">=2.0.0"
  - skill: security-audit
    version: ">=1.0.0"
  - skill: performance-check
    optional: true

composition:
  type: parallel
  merge_strategy: aggregate
```

### 组合声明示例

在 Skill 中声明组合关系：

```markdown
## 依赖的 Skill

| Skill | 用途 | 必需 |
|-------|------|------|
| code-review | 代码质量审查 | ✅ |
| security-audit | 安全漏洞检查 | ✅ |
| performance-check | 性能分析 | ❌ |

## 组合流程

1. 并行执行 code-review 和 security-audit
2. 如果可用，执行 performance-check
3. 合并所有结果生成综合报告
```

### Composable AI Workforce

2026 年趋势：从单一 Agent 到可组合 AI 团队

```
传统：一个全能 Agent
└─ 问题：复杂、难维护、不灵活

趋势：多个专精 Agent 组成团队
├─ 每个 Agent 负责特定领域
├─ 通过编排层协调工作
└─ 可动态组合应对不同任务
```

### 实现建议

```markdown
## Skill 组合最佳实践

1. **保持 Skill 单一职责**
   - 每个 Skill 只做一件事，做好
   - 复杂功能通过组合实现

2. **定义清晰的接口**
   - 明确输入格式
   - 明确输出格式
   - 便于其他 Skill 对接

3. **松耦合设计**
   - Skill 之间通过标准格式通信
   - 避免直接依赖内部实现

4. **优雅降级**
   - 可选依赖不可用时仍能工作
   - 提供降级后的基本功能
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: reddit.com, gend.co, flowgpt -->
<!-- Compressed: 2026-01-13 | reason: 精简冗长示例 -->
## 社区分享机制

Skill 的导出、分享与复用。

### 导出格式

| 格式 | 用途 | 关键字段 |
|-----|------|---------|
| 标准版 (YAML) | 完整元数据 | metadata, compatibility, dependencies |
| 轻量版 (MD) | 快速分享 | Tags, Platform, 核心功能 |

### 分享平台

| 平台 | 特点 | 适用场景 |
|-----|------|---------|
| GitHub | 版本控制 | 团队/开源 |
| Gist | 快速分享 | 临时分享 |
| FlowGPT | 社区评分 | 发现 Skill |

### Skill 库结构

```
~/.claude-skills/          ← 全局库
├── registry.json          ← 索引
└── installed/             ← 已安装
```

### 分享检查清单

- [ ] 去除敏感信息（API 密钥、内部路径）
- [ ] 通用化（移除项目特定内容）
- [ ] 添加示例和许可证
- [ ] 在干净环境测试

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: medium.com, generativeai.pub, towardsai.net -->
<!-- Compressed: 2026-01-13 | reason: 精简冗长示例 -->
## RAG 集成策略

大型 Skill 按需检索，节省 context。

### 分块策略

| 策略 | 适用场景 | 说明 |
|-----|---------|------|
| 层级分块 | 结构化 Skill | Parent(章节) + Child(规则)，命中 Child 返回 Parent |
| 语义分块 | 通用内容 | 按标题切分，保持代码块完整 |
| 滑动窗口 | 连续内容 | 500 tokens 窗口，50 tokens 重叠 |

### RAG 架构

```
.claude/skills/<name>/
├── SKILL.md           ← 原始内容
├── SKILL.summary.md   ← 精简版（总是加载）
└── chunks/            ← 分块索引 + 向量嵌入
```

### 何时使用 RAG

| 条件 | 建议 |
|-----|------|
| Skill > 500 行 | 使用 RAG |
| 内容多主题 | 使用 RAG |
| Skill < 200 行 | 不需要 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: observability pipelines, systematic evaluation -->
<!-- Compressed: 2026-01-13 | reason: 精简诊断流程 -->
## Skill 调试与诊断

### 诊断层级（自底向上）

| 层级 | 检查项 | 诊断方法 |
|-----|-------|---------|
| L1 加载 | 文件存在？YAML 正确？ | `ls .claude/skills/<name>/SKILL.md` |
| L2 触发 | description 覆盖？被抢占？ | 检查 description，手动 `/skill-name` |
| L3 执行 | 流程完整？示例可用？ | 对照日志，验证示例 |
| L4 业务 | 解决问题？符合预期？ | 用户反馈 |

### 常见问题速查

| 问题 | 原因 | 解决 |
|-----|------|------|
| 不触发 | description 不匹配 | 丰富触发词，覆盖中英文 |
| 执行不完整 | 流程有歧义/依赖缺失 | 明确步骤，检查依赖 |
| 输出不符预期 | Format/Constraints 不清 | 添加示例，强化约束 |

### 健康检查周期

| 周期 | 检查项 |
|-----|-------|
| 每周 | 触发率、用户反馈 |
| 每月 | 示例有效性、依赖可用性 |
| 每季 | 流程完整性、业界对比 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: circuit breakers, fallback strategies, self-healing -->
<!-- Compressed: 2026-01-13 | reason: 精简错误恢复内容 -->
## 错误恢复与降级

### 弹性原则

| 原则 | 说明 |
|-----|------|
| 预期失败 | 假设任何步骤都可能失败 |
| 快速失败 | 尽早检测，避免级联 |
| 优雅降级 | 部分失败仍提供基本服务 |
| 自我恢复 | 自动检测和恢复常见问题 |

### 熔断器模式

```
CLOSED ──失败3次──→ OPEN ──5分钟后──→ HALF-OPEN ──成功──→ CLOSED
                      ↑                    │
                      └────失败────────────┘
```

### 回退策略层级

| 层级 | 策略 | 说明 |
|-----|------|------|
| L1 | 重试 | 简单重试/指数退避 |
| L2 | 替代 | 用其他工具/Skill |
| L3 | 降级 | 返回缓存/部分功能 |
| L4 | 安全失败 | 告知用户，记录问题 |

### 功能优先级

| 优先级 | 降级策略 |
|-------|---------|
| P0 核心 | 不降级，失败则告警 |
| P1 重要 | 降级为基础版 |
| P2 可选 | 可跳过 |

### 错误分类

| 错误类型 | 处理策略 |
|---------|---------|
| 暂时性（网络/超时） | 重试 |
| 配置错误 | 修正后重试 |
| 依赖错误 | 降级或替代 |
| 逻辑错误 | 修复 Skill |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: LLMLingua, TOON format, semantic summarization -->
<!-- Compressed: 2026-01-13 | reason: 精简 Token 优化内容 -->
## Token 优化技术

### 压缩技术对比

| 技术 | 压缩率 | 适用场景 |
|-----|-------|---------|
| TOON 格式 | 30-50% | 结构化内容 |
| 语义摘要 | 50-70% | 长篇描述 |
| 关键词提取 | 60-80% | 索引/检索 |

### TOON 格式示例

```
# 传统 → TOON
"检查 SQL 注入风险" → "SQL注入→参数化查询"
"确保没有硬编码密钥" → "密钥→禁硬编码"
```

### 分层压缩

| 层级 | 内容 | 大小 |
|-----|------|------|
| 索引层 | 章节标题 | ~10% |
| 摘要层 | 核心要点 | ~30% |
| 完整层 | 全部内容 | 100% |

### Skill 瘦身清单

| 检查项 | 可删除条件 |
|-------|----------|
| 冗余示例 | 同类 > 2 个 |
| 解释性文字 | 规则已清晰 |
| 重复内容 | 多处相同 |

### Token 预算

| 层级 | 单 Skill | 组合 Skill |
|-----|---------|-----------|
| 索引 | < 100 | - |
| 摘要 | < 500 | 辅助各 < 500 |
| 完整 | < 2000 | 主 < 1000，总 < 3000 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: Langfuse, Maxim AI, Braintrust -->
<!-- Compressed: 2026-01-13 | reason: 精简可观测性内容 -->
## 可观测性

### 三大支柱

| 支柱 | 内容 |
|-----|------|
| Metrics | 触发次数、成功率、响应时间 |
| Traces | 请求链路：触发→加载→执行→输出 |
| Logs | 关键决策、错误详情、调试信息 |

### 关键指标

| 指标 | 告警阈值 |
|-----|---------|
| 触发率 | < 70% 需优化 description |
| 成功率 | < 90% 需检查质量 |
| 平均耗时 | > 30s 需优化 |
| 降级率 | > 10% 需检查依赖 |

### 日志级别

| 级别 | 用途 |
|-----|------|
| ERROR | 执行失败 |
| WARN | 降级、超时 |
| INFO | 触发、完成 |
| DEBUG | 中间结果 |

### 工具推荐

| 工具 | 适用场景 |
|-----|---------|
| Langfuse | 自托管、隐私敏感 |
| Braintrust | A/B 测试 |
| 本地日志 | 个人/小团队 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: dev.to, getmaxim.ai, medium.com -->
## Skill 版本管理

将软件工程的版本控制最佳实践应用于 Skill 管理。

### 语义版本控制 (SemVer)

```
版本号格式：X.Y.Z

X (Major) - 重大变更
├─ 核心流程重构
├─ 输出格式根本改变
└─ 不兼容的 API 变更

Y (Minor) - 新增功能
├─ 添加新章节
├─ 扩展检查清单
└─ 增加新的触发词

Z (Patch) - 修复补丁
├─ 修复错别字
├─ 更新过时链接
└─ 小幅措辞调整
```

**版本号示例**：

| 变更内容 | 版本变化 |
|---------|---------|
| 修复示例代码中的语法错误 | 1.0.0 → 1.0.1 |
| 添加 Vue 3 组件审查章节 | 1.0.1 → 1.1.0 |
| 重写整个审查流程 | 1.1.0 → 2.0.0 |

### YAML Frontmatter 版本标记

```yaml
---
name: code-review
description: 审查代码
version: 2.1.3
last_updated: 2026-01-13
min_compatible: 2.0.0
---
```

| 字段 | 说明 |
|-----|------|
| version | 当前版本号 |
| last_updated | 最后更新日期 |
| min_compatible | 最低兼容版本（用于依赖管理） |

### 解耦策略

```
传统方式（耦合）：
├─ Skill 内容硬编码在代码中
├─ 修改需要重新部署
└─ 难以快速迭代

推荐方式（解耦）：
├─ Skill 存储在独立文件/仓库
├─ 动态加载，支持热更新
├─ 版本独立管理
└─ 支持 A/B 测试
```

### 发布流程

```
1. 开发阶段
   ├─ 在分支上修改 Skill
   ├─ 本地测试验证
   └─ 版本号暂定（如 2.2.0-beta）

2. 评审阶段
   ├─ 提交 PR 请求 review
   ├─ 运行自动化测试
   └─ 人工评审内容质量

3. 预发布阶段
   ├─ 合并到预发布分支
   ├─ 小范围灰度测试
   └─ 收集反馈

4. 正式发布
   ├─ 更新版本号
   ├─ 添加 CHANGELOG 记录
   ├─ 合并到主分支
   └─ 打 tag 标记版本

5. 发布后监控
   ├─ 监控关键指标
   ├─ 收集用户反馈
   └─ 准备热修复（如需要）
```

### CHANGELOG 模板

```markdown
# Changelog

## [2.1.0] - 2026-01-13

### Added
- 新增 React 组件审查章节
- 添加 Vue 3 Composition API 检查

### Changed
- 更新 TypeScript 检查规则
- 优化输出报告格式

### Fixed
- 修复安全检查遗漏的 XSS 场景
- 修正示例代码语法错误

### Deprecated
- 废弃旧的 Class 组件检查（将在 3.0 移除）
```

### 回滚策略

```markdown
## 回滚决策树

发现问题后：
├─ 问题影响范围？
│   ├─ 核心功能不可用 → 立即回滚
│   ├─ 部分功能异常 → 评估后决定
│   └─ 小问题 → 热修复
│
├─ 回滚方式
│   ├─ 快速回滚：恢复上一版本备份
│   ├─ 版本回滚：切换到指定历史版本
│   └─ 部分回滚：只回滚问题章节
│
└─ 回滚后操作
    ├─ 通知相关人员
    ├─ 分析问题根因
    └─ 制定修复计划
```

### 版本兼容性管理

```markdown
## 依赖兼容性声明

当 Skill A 依赖 Skill B 时：

skill-manifest.yaml:
dependencies:
  - skill: code-review
    version: ">=2.0.0 <3.0.0"
  - skill: security-audit
    version: "^1.5.0"

版本约束语法：
- "2.1.0"     精确版本
- ">=2.0.0"   最低版本
- "<3.0.0"    最高版本
- "^1.5.0"    兼容 1.x（>=1.5.0 <2.0.0）
- "~1.5.0"    补丁兼容（>=1.5.0 <1.6.0）
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: machinelearningmastery.com, adaline.ai, microsoft.com -->
## 多智能体编排

将 Skill 扩展为可协作的智能体系统。

### 2026 趋势：从单体到多智能体

```
2024-2025：单一全能 Agent
└─ 一个 Agent 处理所有任务
└─ 问题：复杂、难维护、性能瓶颈

2026+：多智能体编排
└─ 专精 Agent 团队协作
└─ 优势：模块化、可扩展、高效
└─ 类比：AI 的「微服务时代」
```

**关键数据**：Gartner 报告多智能体系统咨询量从 2024 Q1 到 2025 Q2 增长 1,445%。

### 编排模式

#### 1. 顺序编排（Sequential）

```
Agent A → Agent B → Agent C → 输出

特点：
├─ 线性流水线
├─ 每个 Agent 处理前一个的输出
└─ 适合：有明确步骤的任务

示例：文档生成流水线
需求分析 Agent → 大纲生成 Agent → 内容撰写 Agent → 审校 Agent
```

#### 2. 并行编排（Concurrent）

```
        ┌→ Agent A ─┐
输入 ───┼→ Agent B ─┼→ 合并 → 输出
        └→ Agent C ─┘

特点：
├─ 多 Agent 同时执行
├─ 结果合并汇总
└─ 适合：多维度分析

示例：全面代码审查
        ┌→ 安全审查 Agent ─┐
代码 ───┼→ 性能审查 Agent ─┼→ 综合报告
        └→ 风格审查 Agent ─┘
```

#### 3. 层级编排（Hierarchical）

```
        协调者 Agent
       ┌────┼────┐
       ↓    ↓    ↓
    Agent  Agent  Agent
      A      B      C

特点：
├─ 主 Agent 分配和协调任务
├─ 子 Agent 执行具体工作
└─ 适合：复杂决策场景

示例：项目规划
        项目经理 Agent
       ┌────┼────┐
       ↓    ↓    ↓
    需求   技术   资源
   分析   评估   规划
```

#### 4. 动态编排（Adaptive）

```
输入 → 路由 Agent → 选择合适的 Agent(s) → 输出

特点：
├─ 根据输入动态选择执行路径
├─ 可组合多种模式
└─ 适合：多变的任务类型
```

### Agent 通信协议

| 协议 | 全称 | 用途 |
|-----|------|------|
| **MCP** | Model Context Protocol | Agent 与工具/数据源通信 |
| **A2A** | Agent-to-Agent Protocol | Agent 之间通信 |
| **ACP** | Agent Communication Protocol | 通用 Agent 通信 |
| **ANP** | Agent Network Protocol | 大规模 Agent 网络 |

### Skill 到 Agent 的演进

```markdown
## Skill Agent 化

Level 1: Skill（当前）
└─ 被动触发，执行指令

Level 2: Reactive Agent
└─ 响应事件，有简单决策

Level 3: Proactive Agent
└─ 主动监控，自主行动

Level 4: Collaborative Agent
└─ 与其他 Agent 协作
```

### 多智能体 Skill 配置

```yaml
# multi-agent-skill.yaml

name: comprehensive-code-review
type: multi-agent
orchestration: parallel

agents:
  - name: security-reviewer
    skill: security-audit
    priority: high

  - name: performance-reviewer
    skill: performance-check
    priority: medium

  - name: style-reviewer
    skill: code-style
    priority: low

merge_strategy:
  type: aggregate
  format: unified-report

fallback:
  on_agent_failure: continue
  min_agents_required: 1
```

### 编排最佳实践

```markdown
## 多智能体设计原则

1. **单一职责**
   - 每个 Agent 专注一个领域
   - 避免万能 Agent

2. **松耦合**
   - Agent 通过标准接口通信
   - 不依赖内部实现

3. **容错设计**
   - 单个 Agent 失败不影响整体
   - 提供降级策略

4. **可观测性**
   - 追踪跨 Agent 调用链
   - 监控各 Agent 性能

5. **资源管理**
   - 控制并发 Agent 数量
   - 避免资源争抢
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: arxiv.org, openreview.net, researchgate.net -->
## 多语言支持

让 Skill 在不同语言和文化环境下有效工作。

### 多语言策略对比

| 策略 | 说明 | 优势 | 劣势 |
|-----|------|------|------|
| **单语言（英语）** | Skill 只用英语编写 | 简单，英语迁移性好 | 非英语用户体验差 |
| **多版本** | 每种语言一个 Skill 版本 | 本地化体验好 | 维护成本高 |
| **自适应** | 检测语言动态响应 | 灵活 | 实现复杂 |
| **混合** | 核心英语 + 输出本地化 | 平衡 | 需要策略设计 |

### 推荐：混合策略

```markdown
## 混合多语言方案

### 核心内容（英语）
- Skill 逻辑和流程用英语
- 模型对英语理解最好
- 便于维护和更新

### 输出本地化
- 根据用户语言输出
- 使用语言标记指示

### 示例
```yaml
---
name: code-review
description: 审查代码。Review code. コードレビュー。
default_language: auto
supported_languages: [zh, en, ja, ko]
---

# Code Review Process

## Output Language
Respond in the same language as the user's request.
If unclear, use English.
```

### 文化感知提示

```markdown
## 多文化提示技术

### 问题：单一文化偏见
LLM 训练数据以英语为主，可能忽略其他文化

### 解决：文化线索注入

传统提示：
「列举三个节日」
→ 可能只返回西方节日

文化感知提示：
「作为了解东亚文化的专家，列举三个重要节日，
  考虑中国、日本、韩国的传统」
→ 返回更多元的结果
```

### 语言检测与路由

```markdown
## 自动语言处理

### 检测策略
1. 显式声明：用户指定语言
2. 请求推断：根据请求语言
3. 环境变量：系统区域设置
4. 默认回退：使用英语

### 路由逻辑
if user_specified_language:
    use(user_specified_language)
elif can_detect_from_request:
    use(detected_language)
elif system_locale_available:
    use(system_locale)
else:
    use("en")
```

### 多语言 Skill 模板

```yaml
---
name: code-review
description: |
  EN: Review TypeScript/JavaScript code for quality issues.
  ZH: 审查 TypeScript/JavaScript 代码质量问题。
  JA: TypeScript/JavaScript コードの品質問題をレビュー。
languages:
  default: en
  supported: [en, zh, ja, ko, es, fr, de]
  output_localization: true
---

# Code Review

## Language Behavior

### Input Processing
- Accept requests in any supported language
- Process using English-based logic (best model performance)

### Output Generation
- Match output language to input language
- Use culturally appropriate examples when relevant

### Fallback
- If language unclear: respond in English
- If translation uncertain: include English alongside
```

### 跨语言迁移

```markdown
## 研究发现：英语提示的跨语言能力

研究表明，英语编写的提示可以有效处理其他语言的任务：

| 场景 | 英语提示效果 | 建议 |
|-----|------------|------|
| 拉丁语系 | 接近原生 | 可直接使用英语提示 |
| 东亚语言 | 略有下降 | 可使用英语，复杂任务本地化 |
| 非拉丁字母 | 效果较差 | 建议本地化 |

### 实践建议
1. 核心逻辑用英语（最佳理解）
2. 输出根据用户语言调整
3. 专业术语保留原文
4. 文化相关内容做本地化
```

### 本地化检查清单

创建多语言 Skill 时检查：

- [ ] **description 多语言**：包含主要语言的触发词
- [ ] **输出语言声明**：明确输出语言策略
- [ ] **文化适配**：示例和场景考虑文化差异
- [ ] **术语一致**：专业术语翻译统一
- [ ] **测试覆盖**：在各目标语言测试
- [ ] **回退机制**：语言不支持时的处理

---

## 背景知识：Skill 的本质与原理

### Skill 是什么

Skill **不是**大模型的内置能力，而是 Claude Code 产品层面的功能。

**本质**：Prompt 模板 + 自动注入机制

**工作流程**：
```
用户输入 → Claude Code CLI → 匹配 Skill → 注入 Prompt → 发送给模型
```

### 触发机制

Skill 通过 `description` 字段进行**语义匹配**（不是精确关键词匹配）：

1. Claude Code 扫描 `.claude/skills/` 目录
2. 读取每个 skill 的 `description` 字段
3. 模型判断用户请求是否与 description 相关
4. 匹配成功 → 将 SKILL.md 内容注入 prompt

### 有概率不触发

由于是模糊匹配，skill 可能不触发：

| 原因 | 解决方法 |
|-----|---------|
| description 太模糊 | 写具体、包含多种表述 |
| 用户表述不匹配 | 在 description 中覆盖用户可能的说法 |
| 多个 skill 竞争 | 让 description 更精准 |

**提高触发率的方法**：
```yaml
# 好的 description
description: 审查代码。当用户请求 review、代码审查、检查代码、"帮我看看这段代码" 时使用。

# 差的 description
description: 帮助处理代码
```

### 其他产品的类似概念

| 产品 | 名称 | 本质 |
|-----|------|------|
| Claude Code | Skill | Prompt 模板 |
| OpenAI | Custom GPT / Instructions | Prompt 模板 |
| Cursor | Rules | Prompt 模板 |
| GitHub Copilot | Instructions | Prompt 模板 |
| LangChain | Prompt Template | Prompt 模板 |

### 关键认知

- Skill 是产品功能，不是 AI 行业通用标准
- Skill 是一种 Prompt 管理和复用方案
- 好的 `description` 是 skill 能否自动触发的关键
