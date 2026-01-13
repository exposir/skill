#!/bin/bash
# detect-failure.sh
# 检测 Bash 命令失败，判断是否与 skill 相关
# 仅输出提示信号，不自动修改

TOOL_OUTPUT="$1"
EXIT_CODE="$2"

# 只在命令失败时处理
if [ "$EXIT_CODE" != "0" ] && [ -n "$EXIT_CODE" ]; then

    # 检查是否存在 skills 目录
    SKILLS_DIR=".claude/skills"
    if [ ! -d "$SKILLS_DIR" ]; then
        exit 0
    fi

    # 输出失败信号，供 Claude 读取分析
    echo "[SKILL-EVOLUTION] Command failed with exit code: $EXIT_CODE"
    echo "[SKILL-EVOLUTION] Consider checking if this failure relates to any skill advice."
    echo "[SKILL-EVOLUTION] If a skill caused this error, you may want to correct it."
fi

exit 0
