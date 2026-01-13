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
## 无极进化

**与普通进化的区别：**
- 普通进化：从当前对话上下文提取知识
- 无极进化：主动搜索互联网和 GitHub，不依赖上下文

### 触发方式

用户说：
- "无极进化 <skill-name>"
- "无级进化 <skill-name>"
- "主动优化 <skill-name>"

### 执行流程

```
1. 选择目标 Skill
   └─ 用户指定或从列表选择

2. 问题诊断
   ├─ 读取当前 skill 内容
   ├─ 分析结构完整性
   ├─ 检查是否有过时内容
   └─ 识别可优化点

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

4. 分析与建议
   ├─ 对比当前 skill 与最新知识
   ├─ 识别差距和改进点
   └─ 生成优化建议报告

5. 用户确认
   └─ 展示建议，等待用户确认

6. 执行进化
   ├─ 备份当前版本
   ├─ 应用优化内容
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

### 搜索到的最新知识
1. **[知识点1]** — 来源：<URL>
2. **[知识点2]** — 来源：<URL>
3. ...

### 优化建议
| # | 建议内容 | 优先级 | 来源 |
|---|---------|-------|------|
| 1 | xxx | 高/中/低 | <来源> |
| 2 | xxx | 高/中/低 | <来源> |

### 建议操作
- [ ] 添加 xxx 章节
- [ ] 更新 xxx 内容
- [ ] 删除过时的 xxx

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

<!-- Added: 2026-01-13 | source: 对话总结 | trigger: 手动进化 -->
<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: braintrust.dev, getmaxim.ai, anthropic.com -->
## Skill 评估与测试

### 为什么需要评估

Skill 不是写完就结束，需要持续验证其效果：

```
写 Skill → 测试 → 部署 → 监控 → 优化 → 循环
```

### 评估方法

#### 1. A/B 测试

对比不同版本的 skill 效果：

```markdown
## A/B 测试记录

| 版本 | 变更内容 | 测试场景 | 成功率 | 结论 |
|-----|---------|---------|-------|------|
| v1 | 原始版本 | 代码审查 x10 | 70% | 基准 |
| v2 | 增加示例 | 代码审查 x10 | 85% | ✅ 采用 |
| v3 | 简化流程 | 代码审查 x10 | 65% | ❌ 回滚 |
```

#### 2. 回归测试

每次修改后验证核心功能不退化：

```markdown
## 回归测试清单

- [ ] 触发词能正确触发 skill
- [ ] 核心流程能完整执行
- [ ] 示例代码能正常运行
- [ ] 输出格式符合预期
```

#### 3. LLM-as-Judge 自动评估

让模型评估 skill 执行效果：

```
提示词模板：
"请评估以下 skill 执行结果的质量（1-5分）：
- 是否解决了用户问题
- 输出是否清晰有用
- 是否遵循了 skill 中的流程

执行结果：<结果内容>"
```

### 测试流程

```
1. 定义测试用例
   ├─ 输入：用户请求示例
   ├─ 预期：期望的行为/输出
   └─ 评判标准：成功/失败的判断依据

2. 执行测试
   ├─ 手动测试：实际对话中验证
   └─ 批量测试：多个用例连续验证

3. 记录结果
   ├─ 通过/失败
   ├─ 实际输出
   └─ 问题分析

4. 迭代优化
   └─ 根据测试结果修改 skill
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: getmaxim.ai -->
## 版本回滚与恢复

### 备份管理

每次修改自动创建备份：

```bash
# 备份命名格式
SKILL.md.bak.YYYYMMDD-HHMMSS

# 查看备份列表
ls -la .claude/skills/<name>/SKILL.md.bak.*
```

### 快速回滚

```bash
# 1. 查看备份列表
ls -lt .claude/skills/<skill-name>/SKILL.md.bak.* | head -5

# 2. 对比差异
diff .claude/skills/<skill-name>/SKILL.md \
     .claude/skills/<skill-name>/SKILL.md.bak.<timestamp>

# 3. 执行回滚
cp .claude/skills/<skill-name>/SKILL.md.bak.<timestamp> \
   .claude/skills/<skill-name>/SKILL.md
```

### 版本对比

```markdown
## 版本对比报告

### 当前版本 vs 备份版本

| 章节 | 当前版本 | 备份版本 | 变化 |
|-----|---------|---------|------|
| 审查流程 | 5 步 | 3 步 | +2 步 |
| 示例代码 | 8 个 | 5 个 | +3 个 |
| 检查清单 | 15 项 | 10 项 | +5 项 |

### 新增内容摘要
- 添加了 xxx 章节
- 更新了 xxx 流程

### 删除内容摘要
- 移除了过时的 xxx
```

### 备份清理

保留最近 N 个备份（默认 5 个）：

```bash
# 清理旧备份，保留最新 5 个
ls -t .claude/skills/<name>/SKILL.md.bak.* | tail -n +6 | xargs rm -f
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: braintrust.dev -->
## Skill 效果度量

### 核心指标

| 指标 | 计算方式 | 目标值 |
|-----|---------|-------|
| **触发率** | 触发次数 / 相关请求次数 | > 80% |
| **成功率** | 成功执行 / 触发次数 | > 90% |
| **用户满意度** | 正面反馈 / 总反馈 | > 85% |
| **迭代频率** | 修改次数 / 月 | 适度（1-3次） |

### 度量记录模板

在 `config.md` 中记录：

```markdown
## Skill 度量记录

### code-review
| 月份 | 触发次数 | 成功次数 | 失败原因 |
|-----|---------|---------|---------|
| 2026-01 | 25 | 23 | 2次：示例过时 |
| 2026-02 | 30 | 28 | 2次：边界情况 |

### 趋势分析
- 触发率稳定在 85%
- 主要失败原因：示例代码过时
- 建议：每月验证示例有效性
```

### 失败分析

当 skill 执行失败时，记录并分析：

```markdown
## 失败分析

| 日期 | Skill | 失败场景 | 根因 | 修复状态 |
|-----|-------|---------|------|---------|
| 01-10 | code-review | Vue 3 组件 | 缺少 Vue 3 章节 | ✅ 已修复 |
| 01-12 | frontend-daily | 搜索超时 | API 限制 | ⏳ 待处理 |
```

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: getmaxim.ai -->
## 协作工作流

### 多人协作场景

当团队共享 skill 时：

```
├─ 个人 skill：~/.claude/skills/（个人使用）
├─ 项目 skill：<project>/.claude/skills/（项目组共享）
└─ 团队 skill：共享仓库（跨项目复用）
```

### 变更审核流程

```
1. 提议变更
   └─ 创建变更说明（为什么要改、改什么）

2. 评审
   ├─ 团队成员 review 变更内容
   └─ 讨论潜在影响

3. 测试
   └─ 在测试环境验证

4. 合并
   ├─ 合并到主分支
   └─ 通知团队成员

5. 监控
   └─ 观察变更后的效果
```

### Git 工作流集成

```bash
# 分支策略
main          # 稳定版本
├─ dev        # 开发版本
└─ feat/xxx   # 特定 skill 改进

# 提交规范
git commit -m "skill(code-review): 添加 React 组件审查章节"
git commit -m "skill(frontend-daily): 修复 RSS 源解析问题"

# PR 模板
## Skill 变更说明

### 变更的 Skill
- [ ] code-review
- [ ] frontend-daily

### 变更类型
- [ ] 新增功能
- [ ] 修复问题
- [ ] 内容更新

### 变更内容
<描述具体改动>

### 测试结果
<测试通过的证据>
```

### 冲突解决

当多人同时修改同一 skill 时：

| 冲突类型 | 解决策略 |
|---------|---------|
| 新增章节冲突 | 通常可合并，检查顺序 |
| 修改同一章节 | 讨论后选择最佳版本 |
| 删除 vs 修改 | 优先保留，讨论是否真需删除 |

---

<!-- Evolved: 2026-01-13 | type: 无极进化 | sources: anthropic.com, skywork.ai -->
## 进化策略进阶

### Agentic Memory 模式

将知识存储在 context 外，按需加载：

```
传统模式：
┌─────────────────────────────┐
│ Context Window              │
│ ┌─────────────────────────┐ │
│ │ Skill A 全部内容        │ │
│ │ Skill B 全部内容        │ │
│ │ Skill C 全部内容        │ │
│ │ ... (容易溢出)          │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘

Agentic Memory 模式：
┌─────────────────────────────┐
│ Context Window              │
│ ┌─────────────────────────┐ │
│ │ 当前任务相关的 Skill    │ │
│ │ 按需加载的章节          │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
         ↑ 按需读取
┌─────────────────────────────┐
│ 外部存储 (.claude/skills/)  │
│ - Skill A, B, C, D...       │
└─────────────────────────────┘
```

### Just-in-Time 加载策略

```markdown
## 大型 Skill 拆分建议

当 skill 超过 500 行时，考虑拆分：

```
.claude/skills/code-review/
├── SKILL.md           # 主文件（核心流程 + 索引）
├── security.md        # 安全检查详情
├── performance.md     # 性能检查详情
├── typescript.md      # TypeScript 专项
└── react.md           # React 专项
```

主文件引用子模块：

```markdown
## 安全检查
基础检查见主文件，详细内容见 `security.md`

## 性能检查
基础检查见主文件，详细内容见 `performance.md`
```
```

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
## 5P 结构化框架

标准化的 Skill 结构，确保内容完整且易于 AI 理解。

### 5P 要素

| 要素 | 英文 | 作用 | 示例 |
|-----|------|------|------|
| **角色** | Role | 定义 AI 扮演的角色 | "你是一个资深前端工程师" |
| **目标** | Goal | 明确要达成的结果 | "审查代码并发现潜在问题" |
| **上下文** | Context | 提供必要的背景信息 | "这是一个 React 项目，使用 TypeScript" |
| **格式** | Format | 指定输出格式 | "以 Markdown 表格输出，按严重程度排序" |
| **约束** | Constraints | 边界条件和限制 | "只关注安全和性能问题，忽略代码风格" |

### 应用到 Skill 模板

```markdown
---
name: <skill-name>
description: <触发描述>
---

# <Skill 标题>

## Role（角色定位）
你是一个 [专业角色]，擅长 [核心能力]。

## Goal（目标）
帮助用户 [达成什么结果]。

## Context（上下文）
### 适用场景
- 场景 1
- 场景 2

### 前置条件
- 条件 1
- 条件 2

## Format（输出格式）
[使用什么格式输出，如表格、列表、代码块等]

## Constraints（约束）
- 必须做的事
- 禁止做的事
- 边界条件

## Execution（执行流程）
1. 步骤 1
2. 步骤 2
3. ...
```

### 5P 检查清单

创建或更新 Skill 时，逐项检查：

- [ ] **Role**：角色是否明确？专业领域是否清晰？
- [ ] **Goal**：目标是否具体可衡量？
- [ ] **Context**：背景信息是否充足？适用场景是否清楚？
- [ ] **Format**：输出格式是否明确？是否有示例？
- [ ] **Constraints**：边界条件是否完整？是否有负面约束（不应做什么）？

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
## Memory Bank 模式

实现跨会话的知识持久化和上下文保留。

### 与 Agentic Memory 的关系

```
Agentic Memory（之前章节）
└─ 概念：将知识存储在 context 外，按需加载

Memory Bank（本章节）
└─ 实现：具体的持久化存储方案和工作流
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
