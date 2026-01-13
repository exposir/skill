# Skill Evolution 配置

## 管理范围

当前模式：**全部 skill**

- [x] 全部 skill（.claude/skills/*）
- [ ] 仅特定分类：
- [ ] 仅项目知识

## 提示设置

| 配置项 | 当前值 | 说明 |
|-------|-------|------|
| 进化提示上限 | 3 次/会话 | 同一会话最多提示次数 |
| 验证周期 | 30 天 | 多久未验证时提示 |
| 备份保留数 | 5 | 保留最近几个备份 |

## 自定义分类

| 分类 | 路径 | 说明 | 创建时间 |
|-----|------|------|---------|
| code-review | .claude/skills/code-review/ | 代码审查 | 2026-01-13 |
| skill-generator | .claude/skills/skill-generator/ | Skill 生成器 | 2026-01-13 |
| frontend-daily | .claude/skills/frontend-daily/ | 前端技术速览 | 2026-01-13 |
| skill-evolution | .claude/skills/skill-evolution/ | 自我进化系统 | 2026-01-13 |

## 忽略列表

以下 skill 不会被进化系统管理：

- skill-evolution（避免自我循环）

## 验证记录

| Skill | 最后验证 | 状态 |
|-------|---------|------|
| code-review | 2026-01-13 | ✅ 通过 |
| frontend-daily | 2026-01-13 | ✅ 已修正 |
| skill-generator | 2026-01-13 | ✅ 通过 |
| skill-evolution | 2026-01-13 | ✅ 通过 |

---

*配置修改方式：直接说"修改 skill 配置"或具体修改内容*
