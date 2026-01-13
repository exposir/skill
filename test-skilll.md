---
name: makepad-evolution
description: Self-improving skill system for Makepad development. Features self-evolution (accumulate knowledge), self-correction (fix errors automatically), self-validation (verify accuracy), usage feedback (track pattern health), version adaptation (multi-branch support), and personalization (adapt to project style).
---

# Makepad Skills Evolution

# Makepad 技能进化

This skill enables makepad-skills to self-improve continuously during development.
此技能使得 makepad-skills 能够在开发过程中持续自我改进。

## Quick Navigation

## 快速导航

| Topic                                       | Description                       |
| ------------------------------------------- | --------------------------------- |
| [Hooks Setup](#hooks-based-auto-triggering) | Auto-trigger evolution with hooks |
| [When to Evolve](#when-to-evolve)           | Triggers and classification       |
| [Evolution Process](#evolution-process)     | Step-by-step guide                |
| [Self-Correction](#self-correction)         | Auto-fix skill errors             |
| [Self-Validation](#self-validation)         | Verify skill accuracy             |
| [Version Adaptation](#version-adaptation)   | Multi-branch support              |

| 主题                                       | 描述                    |
| ------------------------------------------ | ----------------------- |
| [Hooks 设置](#hooks-based-auto-triggering) | 使用 Hooks 自动触发进化 |
| [何时进化](#when-to-evolve)                | 触发条件和分类          |
| [进化过程](#evolution-process)             | 分步指南                |
| [自我修正](#self-correction)               | 自动修复技能错误        |
| [自我验证](#self-validation)               | 验证技能准确性          |
| [版本适配](#version-adaptation)            | 多分支支持              |

---

## Hooks-Based Auto-Triggering

## 基于 Hooks 的自动触发

For reliable automatic triggering, use Claude Code hooks. Copy the hooks to your project:
为了实现可靠的自动触发，请使用 Claude Code hooks。将 hooks 复制到你的项目中：

```bash
# Copy hooks to your project
cp -r .claude/skills/99-evolution/hooks your-project/.claude/skills/hooks
chmod +x your-project/.claude/skills/hooks/*.sh
```

Then merge `hooks/settings.example.json` into your `.claude/settings.json`:
然后将 `hooks/settings.example.json` 合并到你的 `.claude/settings.json` 中：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/skills/hooks/pre-tool.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/skills/hooks/post-bash.sh \"$TOOL_OUTPUT\" \"$EXIT_CODE\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/skills/hooks/session-end.sh"
          }
        ]
      }
    ]
  }
}
```

### What Hooks Do

### Hooks 的作用

| Hook             | Trigger Event            | Action                                 |
| ---------------- | ------------------------ | -------------------------------------- |
| `pre-tool.sh`    | Before Bash/Write/Edit   | Detect Makepad version from Cargo.toml |
| `post-bash.sh`   | After Bash command fails | Detect Makepad errors, suggest fixes   |
| `session-end.sh` | Session ends             | Prompt to capture learnings            |

| Hook             | 触发事件             | 动作                            |
| ---------------- | -------------------- | ------------------------------- |
| `pre-tool.sh`    | Bash/Write/Edit 之前 | 从 Cargo.toml 检测 Makepad 版本 |
| `post-bash.sh`   | Bash 命令失败后      | 检测 Makepad 错误，建议修复     |
| `session-end.sh` | 会话结束             | 提示捕捉学习内容                |

---

## When to Evolve

## 何时进化

Trigger skill evolution when any of these occur during development:
当开发过程中发生以下任何情况时触发技能进化：

| Trigger                        | Target Skill                 | Priority |
| ------------------------------ | ---------------------------- | -------- |
| New widget pattern discovered  | 04-patterns                  | High     |
| Shader technique learned       | 03-graphics                  | High     |
| Compilation error solved       | 06-reference/troubleshooting | High     |
| Layout solution found          | 06-reference/adaptive-layout | Medium   |
| Build/packaging issue resolved | 05-deployment                | Medium   |
| New project structure insight  | 00-getting-started           | Low      |
| Core concept clarified         | 01-core                      | Low      |

| 触发条件            | 目标技能                     | 优先级 |
| ------------------- | ---------------------------- | ------ |
| 发现新的组件模式    | 04-patterns                  | 高     |
| 学习了着色器技术    | 03-graphics                  | 高     |
| 解决了编译错误      | 06-reference/troubleshooting | 高     |
| 找到了布局解决方案  | 06-reference/adaptive-layout | 中     |
| 解决了构建/打包问题 | 05-deployment                | 中     |
| 新的项目结构见解    | 00-getting-started           | 低     |
| 核心概念阐明        | 01-core                      | 低     |

---

## Evolution Process

## 进化过程

### Step 1: Identify Knowledge Worth Capturing

### 第一步：识别值得记录的知识

Ask yourself:
问问自己：

- Is this a reusable pattern? (not project-specific)
- 这是一个可重用的模式吗？（非特定于项目的）
- Did it take significant effort to figure out?
- 弄清楚它是否花了很大的力气？
- Would it help other Makepad developers?
- 它会对其他 Makepad 开发者有帮助吗？
- Is it not already documented in makepad-skills?
- 它是否尚未记录在 makepad-skills 中？

### Step 2: Classify the Knowledge

### 第二步：知识分类

```
Widget/Component Pattern     → 04-patterns/
Shader/Visual Effect         → 03-graphics/
Error/Debug Solution         → 06-reference/troubleshooting.md
Layout/Responsive Design     → 06-reference/adaptive-layout.md
Build/Deploy Issue           → 05-deployment/SKILL.md
Project Structure            → 00-getting-started/
Core Concept/API             → 01-core/
```

### Step 3: Format the Contribution

### 第三步：格式化贡献内容

**For Patterns**:
**对于模式**：

````markdown
## Pattern N: [Pattern Name]

Brief description of what this pattern solves.

### live_design!

```rust
live_design! {
    // DSL code
}
```
````

### Rust Implementation

### Rust 实现

```rust
// Rust code
```

````

**For Troubleshooting**:
**对于故障排除**：
```markdown
### [Error Type/Message]

**Symptom**: What the developer sees

**Cause**: Why this happens

**Solution**:
```rust
// Fixed code
````

````

### Step 4: Mark Evolution (NOT Version)
### 第四步：标记进化（非版本）

Add an evolution marker above new content:
在新内容上方添加进化标记：

```markdown
<!-- Evolution: 2024-01-15 | source: my-app | author: @zhangsan -->
````

### Step 5: Submit via Git

### 第五步：通过 Git 提交

```bash
# Create branch for your contribution
git checkout -b evolution/add-loading-pattern

# Commit your changes
git add 04-patterns/widget-patterns.md
git commit -m "evolution: add loading state pattern from my-app"

# Push and create PR
git push origin evolution/add-loading-pattern
```

---

## Self-Correction

## 自我修正

When skill content causes errors, automatically correct it.
当技能内容导致错误时，自动进行修正。

### Trigger Conditions

### 触发条件

```
User follows skill advice → Code fails to compile/run → Claude identifies skill was wrong
                                                      ↓
                                         AUTO: Correct skill immediately
```

### Correction Flow

### 修正流程

1. **Detect** - Skill advice led to an error
1. **检测** - 技能建议导致了错误
1. **Verify** - Confirm the skill content is wrong
1. **验证** - 确认技能内容是错误的
1. **Correct** - Update the skill file with fix
1. **修正** - 更新技能文件并修复

### Correction Marker Format

### 修正标记格式

```markdown
<!-- Correction: YYYY-MM-DD | was: [old advice] | reason: [why it was wrong] -->
```

---

## Self-Validation

## 自我验证

Periodically verify skill content is still accurate.
定期验证技能内容是否仍然准确。

### Validation Checklist

### 验证检查清单

```markdown
## Validation Report

### Code Examples

- [ ] All `live_design!` examples parse correctly
- [ ] All Rust code compiles
- [ ] All patterns work as documented

### API Accuracy

- [ ] Widget names exist in makepad-widgets
- [ ] Method signatures are correct
- [ ] Event types are accurate
```

### Validation Prompt

### 验证提示词

> "Please validate makepad-skills against current Makepad version"
> "请根据当前的 Makepad 版本验证 makepad-skills"

---

## Version Adaptation

## 版本适配

Provide version-specific guidance for different Makepad branches.
针对不同的 Makepad 分支提供特定版本的指导。

### Supported Versions

### 支持的版本

| Branch | Status | Notes                      |
| ------ | ------ | -------------------------- |
| main   | Stable | Production ready           |
| dev    | Active | Latest features, may break |
| rik    | Legacy | Older API style            |

| Branch | 状态 | 备注                 |
| ------ | ---- | -------------------- |
| main   | 稳定 | 生产就绪             |
| dev    | 活跃 | 最新特性，可能不稳定 |
| rik    | 旧版 | 旧版 API 风格        |

### Version Detection

### 版本检测

Claude should detect Makepad version from:
Claude 应通过以下方式检测 Makepad 版本：

1. **Cargo.toml branch reference**:
1. **Cargo.toml 分支引用**：

   ```toml
   makepad-widgets = { git = "...", branch = "dev" }
   ```

1. **Cargo.lock content**
1. **Cargo.lock 内容**

1. **Ask user if unclear**
1. **如果不清楚则询问用户**

---

## Personalization

## 个性化

Adapt skill suggestions to project's coding style.
根据项目的编码风格调整技能建议。

### Style Detection

### 风格检测

Claude analyzes the current project to detect:
Claude 分析当前项目以检测：

| Aspect            | Detection Method       | Adaptation                    |
| ----------------- | ---------------------- | ----------------------------- |
| Naming convention | Scan existing widgets  | Match snake_case vs camelCase |
| Code organization | Check module structure | Suggest matching patterns     |
| Comment style     | Read existing comments | Match documentation style     |
| Widget complexity | Count lines per widget | Suggest appropriate patterns  |

| 方面       | 检测方法         | 适配                     |
| ---------- | ---------------- | ------------------------ |
| 命名规范   | 扫描现有组件     | 匹配蛇形命名 vs 驼峰命名 |
| 代码组织   | 检查模块结构     | 建议匹配的模式           |
| 注释风格   | 阅读现有注释     | 匹配文档风格             |
| 组件复杂度 | 统计每个组件行数 | 建议合适的模式           |

---

## Quality Guidelines

## 质量指南

### DO Add

### 应该添加

- Generic, reusable patterns
- 通用的、可重用的模式
- Common errors with clear solutions
- 带有清晰解决方案的常见错误
- Well-tested shader effects
- 经过充分测试的着色器效果
- Platform-specific gotchas
- 特定平台的坑
- Performance optimizations
- 性能优化

### DON'T Add

### 不应添加

- Project-specific code
- 特定于项目的代码
- Unverified solutions
- 未经验证的解决方案
- Duplicate content
- 重复内容
- Incomplete examples
- 不完整的示例
- Personal preferences without rationale
- 没有依据的个人偏好

---

## Skill File Locations (New Structure)

## 技能文件位置（新结构）

```
skills/
├── 00-getting-started/    ← Project setup
├── 01-core/               ← Layout, widgets, events, styling
├── 02-components/         ← Widget gallery
├── 03-graphics/           ← Shaders, SDF, animations
├── 04-patterns/           ← Production patterns
├── 05-deployment/         ← Build & packaging
├── 06-reference/          ← Troubleshooting, code quality
└── 99-evolution/          ← This file + hooks
    └── hooks/             ← Auto-trigger hooks
```

---

## Auto-Evolution Prompts

## 自动进化提示词

Use these prompts to trigger self-evolution:
使用这些提示词来触发自我进化：

### After Solving a Problem

### 解决问题后

> "This solution should be added to makepad-skills for future reference."
> "这个解决方案应该添加到 makepad-skills 以供将来参考。"

### After Creating a Widget

### 创建组件后

> "This widget pattern is reusable. Let me add it to makepad-patterns."
> "这个组件模式是可重用的。让我把它添加到 makepad-patterns 中。"

### After Debugging

### 调试后

> "This error and its fix should be documented in makepad-troubleshooting."
> "这个错误及其修复方法应该记录在 makepad-troubleshooting 中。"

### After Completing a Feature

### 完成功能后

> "Review what I learned and update makepad-skills if applicable."
> "回顾我学到的内容，并在适用时更新 makepad-skills。"

---

## Continuous Improvement Checklist

## 持续改进检查清单

After each Makepad development session, consider:
在每次 Makepad 开发会话后，思考：

- [ ] Did I discover a new widget composition pattern?
- [ ] 我是否发现了新的组件组合模式？
- [ ] Did I solve a tricky shader problem?
- [ ] 我是否解决了一个棘手的着色器问题？
- [ ] Did I encounter and fix a confusing error?
- [ ] 我是否遇到并修复了一个令人困惑的错误？
- [ ] Did I find a better way to structure layouts?
- [ ] 我是否找到了更好的布局结构方式？
- [ ] Did I learn something about packaging/deployment?
- [ ] 我是否学到了关于打包/部署的知识？
- [ ] Would any of this help other Makepad developers?
- [ ] 这些内容会对其他 Makepad 开发者有帮助吗？

If yes to any, evolve the appropriate skill!
如果任何一项为是，请进化相应的技能！

## References

## 参考资料

- [makepad-skills repository](https://github.com/project-robius/makepad-skills)
- [makepad-skills 仓库](https://github.com/project-robius/makepad-skills)
- [Makepad documentation](https://github.com/makepad/makepad)
- [Makepad 文档](https://github.com/makepad/makepad)
- [Project Robius](https://github.com/project-robius)
- [Project Robius 项目](https://github.com/project-robius)
