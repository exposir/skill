---
name: code-review
description: 审查 TypeScript/JavaScript 代码。当用户请求代码审查、review 代码、检查代码质量、或提到 "帮我看看这段代码" 时使用。
---

# TypeScript/JavaScript 代码审查

## 审查流程

1. **理解上下文**：先了解代码的功能和目的
2. **分层审查**：按优先级依次检查各个维度
3. **给出建议**：提供具体、可操作的改进建议

## 审查维度（按优先级）

### 1. 安全性检查 (Critical)

- [ ] **注入风险**：检查 SQL 注入、XSS、命令注入
- [ ] **敏感数据**：避免硬编码密钥、token、密码
- [ ] **输入验证**：用户输入是否经过验证和清理
- [ ] **依赖安全**：是否使用已知有漏洞的依赖
- [ ] **权限控制**：是否有适当的认证和授权检查

```typescript
// 危险示例
const query = `SELECT * FROM users WHERE id = ${userId}`; // SQL 注入风险
element.innerHTML = userInput; // XSS 风险

// 安全示例
const query = `SELECT * FROM users WHERE id = $1`; // 参数化查询
element.textContent = userInput; // 安全的文本插入
```

### 2. 正确性检查 (High)

- [ ] **边界条件**：空值、空数组、边界值处理
- [ ] **类型安全**：TypeScript 类型是否正确，避免 `any`
- [ ] **错误处理**：异常是否被正确捕获和处理
- [ ] **异步逻辑**：Promise/async-await 是否正确使用
- [ ] **竞态条件**：并发操作是否安全

```typescript
// 问题示例
async function fetchData() {
  const data = await api.get(); // 未处理错误
  return data.items.map(x => x.name); // data.items 可能为 undefined
}

// 改进示例
async function fetchData() {
  try {
    const data = await api.get();
    return data?.items?.map(x => x.name) ?? [];
  } catch (error) {
    console.error('Failed to fetch data:', error);
    return [];
  }
}
```

### 3. 性能检查 (Medium)

- [ ] **算法复杂度**：避免不必要的 O(n²) 操作
- [ ] **内存泄漏**：事件监听器、定时器是否清理
- [ ] **重复计算**：是否有可缓存或 memo 的计算
- [ ] **批量操作**：是否可以批量处理而非逐个处理
- [ ] **懒加载**：大数据是否按需加载

```typescript
// 性能问题
users.forEach(user => {
  const role = roles.find(r => r.id === user.roleId); // O(n*m)
});

// 优化方案
const roleMap = new Map(roles.map(r => [r.id, r])); // O(m)
users.forEach(user => {
  const role = roleMap.get(user.roleId); // O(1)
}); // 总体 O(n+m)
```

### 4. 可维护性检查 (Medium)

- [ ] **命名规范**：变量、函数命名是否清晰表意
- [ ] **函数职责**：单一职责，函数不超过 30 行
- [ ] **代码重复**：是否有可抽取的公共逻辑
- [ ] **魔法数字**：是否使用常量替代硬编码值
- [ ] **注释质量**：复杂逻辑是否有必要注释

### 5. 代码风格 (Low)

- [ ] **一致性**：与项目现有风格保持一致
- [ ] **格式化**：缩进、空格、换行是否规范
- [ ] **导入顺序**：import 语句是否有序

## 输出格式

审查结果按以下格式输出：

```markdown
## 代码审查报告

### 概述
简要描述代码的功能和整体质量评价。

### 发现的问题

#### Critical (必须修复)
- 问题描述 + 具体位置 + 修复建议

#### High (强烈建议修复)
- 问题描述 + 具体位置 + 修复建议

#### Medium (建议改进)
- 问题描述 + 具体位置 + 改进建议

#### Low (可选优化)
- 问题描述 + 具体位置 + 优化建议

### 亮点
列出代码中做得好的地方（如果有）。

### 总结
- 总体评分：⭐⭐⭐⭐☆ (4/5)
- 是否建议合并：是/否/需要修改后再审
```

## 常见问题速查

| 问题类型 | 快速检测方法 |
|---------|-------------|
| XSS | 搜索 `innerHTML`, `dangerouslySetInnerHTML` |
| 硬编码密钥 | 搜索 `password`, `secret`, `token`, `api_key` |
| 未处理 Promise | 搜索缺少 `.catch()` 或 `try-catch` 的 `await` |
| 类型问题 | 搜索 `: any`, `as any` |
| 内存泄漏 | 检查 `addEventListener`, `setInterval` 是否有对应清理 |
