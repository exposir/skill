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

<!-- Evolved: 2026-01-14 | type: 无极进化 | sources: gend.co, medium.com -->
## Hooks 自动检测（可选）

Hooks 用于自动检测进化机会，仅提示不自动修改。

### 新特性（Claude Code 2.1.0+）

| 特性 | 说明 |
|-----|------|
| **Skill Hot-Reload** | Skill 修改后即时生效，无需重启会话 |
| **updatedInput** | 在 PreToolUse 中修正输入，避免阻断 Agent |

### 最佳实践：Let Agent Finish

```
传统方式：每步阻断验证 → 频繁中断，效率低
推荐方式：让 Agent 完成整个计划 → 最后统一验证

实现：使用 UserPromptSubmit hook 或 commit 前验证
```

### PreToolUse 输入修正示例

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "node fix-input.js",
        "timeout": 5000
      }]
    }]
  }
}
```

返回 `{"updatedInput": {...}}` 可无感修正输入。

### 进化检测 Hooks

| Hook | 触发时机 | 作用 |
|-----|---------|------|
| PostToolUse:Bash | 命令失败后 | 检测是否因 skill 导致 |
| Stop | 会话结束时 | 统计可积累的知识 |

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

### 同步方式

提取 description + 跳过 frontmatter → 写入 `.cursor/rules/<name>.mdc`

### 平台差异

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


<!-- Compressed: 2026-01-13 | reason: 精简模板和示例 -->
## Memory Bank 模式

跨会话知识持久化，按需加载到 context。

### 架构

```
.claude/
├── memory/
│   ├── project-context.md   ← 项目上下文（总是加载）
│   ├── session-history/     ← 会话摘要
│   ├── decisions/           ← 架构决策
│   └── learned/             ← 学习到的知识
└── skills/
```

### 加载策略

| 时机 | 加载内容 |
|-----|---------|
| 会话开始 | project-context.md + 最近3个会话摘要 |
| 会话中 | 检测相关话题 → 加载对应记忆 |
| 会话结束 | 生成摘要，更新 project-context |

### Memory → Skill 进化

```
Memory 记录 → 多次使用(≥3次) → 提示创建 Skill → 标记「已提炼」
```

---
---

<!-- Merged: 2026-01-13 | merged: 进化策略进阶+4P Ladder | reason: 统一进化路径 -->
## 进化路径

### 渐进式进化（3个阶段）

| 阶段 | 目标 | 特征 |
|-----|------|------|
| L1 基础版 | 快速上线 | 核心功能、最小可用 |
| L2 增强版 | 迭代优化 | 更多场景、示例补充 |
| L3 专家版 | 深度打磨 | 高级技巧、工具集成 |

### 4P 阶梯（Skill → Agent）

| 层级 | 名称 | 特征 | Skill类型 |
|-----|------|------|---------|
| L1 | Prompts | 单次交互、无状态 | 简单模板 |
| L2 | Playbooks | 多步骤、可复用 | 完整流程+清单 |
| L3 | Plug-ins | 工具集成、有安全边界 | 含工具调用+权限 |
| L4 | Proactive Agents | 自主决策、人工监督 | Agent+HITL |

### 升级路径

```
L1→L2: 添加流程和模板
L2→L3: 集成工具，添加错误处理
L3→L4: 事件驱动，实现 HITL
```

### 知识蒸馏

```
verbose → concise
长篇解释 → 核心要点
多个示例 → 最佳示例
历史原因 → 当前最佳实践
```

---

<!-- Added: 2026-01-14 | source: 无极进化搜索 | trigger: hyscaler.com, analyticsvidhya.com -->
## Agentic Reasoning 推理模式

2026 年 Agentic AI 从实验走向企业应用，Skill 需要支持更高级的推理模式。

### 核心推理模式

| 模式 | 说明 | 适用场景 |
|-----|------|---------|
| **ReAct** | Reasoning + Acting 交替进行 | 需要工具调用的任务 |
| **Reflexion** | 执行后反思，迭代改进 | 复杂问题解决 |
| **Tree-of-Thought** | 多路径探索，选择最优 | 需要规划的任务 |
| **Critique-and-Revise** | 生成→批评→修正循环 | 内容生成、代码审查 |

### ReAct 模式示例

```
Thought: 我需要先了解项目结构
Action: 读取 package.json
Observation: 这是一个 React + TypeScript 项目
Thought: 现在我知道技术栈了，可以开始审查
Action: 读取目标文件
...
```

### 在 Skill 中应用

```markdown
## 执行流程（ReAct 模式）

1. **Thought**: 分析用户请求，确定目标
2. **Action**: 执行第一步操作
3. **Observation**: 观察结果
4. **Thought**: 基于观察调整策略
5. 重复直到完成

## 反思检查点

每完成一个阶段后：
- 目标是否偏离？
- 是否有更好的方法？
- 是否需要回退？
```

### Self-Consistency 提升准确性

```
对同一问题生成多个答案 → 选择最一致的结果

适用：推理任务、决策场景
```

---

<!-- Added: 2026-01-14 | source: 无极进化搜索 | trigger: addyosmani.com, gend.co -->
## Skill 开发最佳实践

来自 2025-2026 年社区总结的最佳实践。

### 效率实践

| 实践 | 说明 |
|-----|------|
| **Let Agent Finish** | 让 Agent 完成整个计划再验证，避免频繁阻断 |
| **Small Iterative Chunks** | 小步迭代，每次 diff < 200 行 |
| **Propose Plan First** | 先提出 3 步计划，再执行 |
| **Input Modification** | 用 updatedInput 无感修正，而非阻断 |

### description 优化

```yaml
# 好的 description（多触发词、明确时机）
description: |
  审查代码质量。当用户请求 review、代码审查、
  检查代码、"帮我看看这段代码" 时使用。

# 差的 description（模糊）
description: 帮助处理代码
```

### 开发流程

```
1. 个人需求驱动 → 先为自己开发
2. 本地测试迭代 → 验证多场景
3. 项目级共享 → .claude/skills/
4. 团队级推广 → 共享仓库
```

### 质量检查清单

- [ ] description 包含多种触发表述？
- [ ] 有具体示例？
- [ ] 流程步骤清晰？
- [ ] 在不同场景测试过？
- [ ] 无敏感信息？

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: aws.com, langwatch.ai, towardsdatascience.com -->

<!-- Compressed: 2026-01-13 | reason: 精简概念解释 -->
## DSPy 自动优化

算法化优化 Prompt，从手工调试转向自动优化。

### 核心概念

| 概念 | 说明 | 类比 Skill |
|-----|------|-----------| 
| Signature | 输入输出结构 | Format 部分 |
| Module | LLM 调用逻辑 | Execution 部分 |
| Optimizer | 自动优化 Prompt | 无极进化自动版 |
| Metric | 评估效果函数 | 效果度量 |

### MIPROv2 流程

```
Bootstrap(提取高分示例) → Propose(生成候选) → Search(贝叶斯搜索) → Validate(验证)
```

### 手动应用原则

| 原则 | 实践 |
|-----|---------| 
| 清晰输入输出 | 使用 5P 框架 |
| 收集示例 | 记录成功案例 |
| 建立指标 | 定义成功标准 |
| 迭代优化 | 根据失败调整 |
| A/B 测试 | 对比版本效果 |

---
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

<!-- Merged: 2026-01-13 | merged: 调试诊断+错误恢复 | reason: 统一故障处理 -->
## 故障处理

### 诊断层级

| 层级 | 检查项 | 诊断方法 |
|-----|-------|---------| 
| L1 加载 | 文件存在？YAML正确？ | `ls .claude/skills/<name>/SKILL.md` |
| L2 触发 | description覆盖？ | 检查description，手动`/skill-name` |
| L3 执行 | 流程完整？示例可用？ | 对照日志，验证示例 |
| L4 业务 | 解决问题？符合预期？ | 用户反馈 |

### 常见问题

| 问题 | 原因 | 解决 |
|-----|------|------|
| 不触发 | description不匹配 | 丰富触发词 |
| 执行不完整 | 流程有歧义 | 明确步骤 |
| 输出不符预期 | Format不清 | 添加示例 |

### 弹性原则

| 原则 | 说明 |
|-----|------|
| 预期失败 | 假设任何步骤都可能失败 |
| 快速失败 | 尽早检测，避免级联 |
| 优雅降级 | 部分失败仍提供基本服务 |

### 回退策略

| 层级 | 策略 | 说明 |
|-----|------|------|
| L1 | 重试 | 简单重试/指数退避 |
| L2 | 替代 | 用其他工具/Skill |
| L3 | 降级 | 返回缓存/部分功能 |
| L4 | 安全失败 | 告知用户，记录问题 |

### 熔断器

```
CLOSED ─失败3次─→ OPEN ─5分钟后─→ HALF-OPEN ─成功─→ CLOSED
```

---
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

<!-- Compressed: 2026-01-13 | reason: 精简编排模式 -->
## 多智能体编排

从单体 Agent 到多专精 Agent 团队协作。

### 编排模式

| 模式 | 说明 | 适用场景 |
|-----|------|---------|
| 顺序 | A→B→C | 有明确步骤的任务 |
| 并行 | A\|B\|C→合并 | 多维度分析 |
| 层级 | 主Agent协调子Agent | 复杂决策 |
| 动态 | 路由Agent选择执行路径 | 多变任务类型 |

### 通信协议

| 协议 | 用途 |
|-----|------|
| MCP | Agent与工具/数据源通信 |
| A2A | Agent之间通信 |

### Skill → Agent 演进

```
L1 Skill(被动) → L2 Reactive(响应事件) → L3 Proactive(主动监控) → L4 Collaborative(协作)
```

### 设计原则

- **单一职责**: 每个Agent专注一个领域
- **松耦合**: 标准接口通信
- **容错**: 单个失败不影响整体
- **可观测**: 追踪跨Agent调用链

---

<!-- Compressed: 2026-01-13 | reason: 精简多语言示例 -->
## 多语言支持

### 策略对比

| 策略 | 优势 | 劣势 |
|-----|------|------|
| 单语言(英语) | 简单，迁移性好 | 非英语体验差 |
| 多版本 | 本地化好 | 维护成本高 |
| 混合(推荐) | 平衡 | 需策略设计 |

### 混合策略

- **核心内容**: 英语（模型理解最好）
- **输出**: 根据用户语言
- **description**: 包含多语言触发词

### 语言检测优先级

```
用户指定 → 请求语言推断 → 系统区域 → 默认英语
```

### 本地化检查清单

- [ ] description 多语言触发词
- [ ] 输出语言声明
- [ ] 文化适配示例
- [ ] 各语言测试覆盖

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

<!-- Added: 2026-01-14 | source: 无极进化搜索 | trigger: dev.to, hyscaler.com -->
### 角色演进：从 Prompt Engineer 到 AI Behavior Architect

2026 年，"Prompt Engineer" 角色正在演进：

| 阶段 | 角色 | 职责 |
|-----|------|------|
| 2023-2024 | Prompt Writer | 编写单次提示词 |
| 2025 | Prompt Engineer | 设计可复用 Prompt 模板 |
| 2026+ | **AI Behavior Architect** | 设计 Agent 行为、管理 Skill 生态 |

**新职责**：
- 设计 Agent 推理流程（ReAct, Reflexion）
- 管理 Skill 生命周期（创建、进化、验证）
- 构建 Prompt 框架和元提示（Meta-Prompt）
- 确保 AI 行为的可靠性、安全性、合规性

**趋势**：
- 日常 Prompt 编写将被自动化
- 重点转向系统设计和行为编排
- Skill 管理成为核心能力
