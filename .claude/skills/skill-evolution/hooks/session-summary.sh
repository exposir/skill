#!/bin/bash
# session-summary.sh
# 会话结束时提示可能值得积累的知识
# 仅输出提示信号，不自动修改

SKILLS_DIR=".claude/skills"

# 检查是否存在 skills 目录
if [ ! -d "$SKILLS_DIR" ]; then
    exit 0
fi

# 统计本次会话信息（简单示例）
SKILL_COUNT=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "[SKILL-EVOLUTION] Session ending."
echo "[SKILL-EVOLUTION] Current skills count: $SKILL_COUNT"
echo "[SKILL-EVOLUTION] Consider: Did you learn something worth capturing?"
echo "[SKILL-EVOLUTION] - New patterns discovered?"
echo "[SKILL-EVOLUTION] - Problems solved?"
echo "[SKILL-EVOLUTION] - Knowledge gained?"
echo ""
echo "[SKILL-EVOLUTION] Say '进化 skill' or '积累知识' to capture learnings."

exit 0
