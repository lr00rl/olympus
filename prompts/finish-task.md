# 神谕 · 结束一个任务(合并 + 通讯)

> 工作循环第⑥步。任何一步失败就停下报告,不得跳步。**做完本流程不是会话终点——回到循环①。**

---

现在收尾任务 **TASK-____**:

## 1. 合并前置(rules/01 §4)

1. 每个涉及仓:`git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}`,解掉全部冲突(判定顺序:contract > plan/pantheon 所有权 > 对方任务与信件;跨所有权冲突先发信)。
2. 全量测试 `{{TEST_COMMANDS}}`,向人类报**真实数字**(passed/failed),禁止"应该没问题"。
3. **ack 检查**:触及契约 / 他人独占区 / 共享文件 / 共享资源 / 鉴权 / 他人权威领域的代码?
   - 是 → 确认信里已有对应 owner 的 `[ack]`;没有 → 停,发/催信,本任务挂起,**换任务继续循环**。
   - 否 → 继续。

## 2. 合并(任务 owner 自己执行;多仓按 {{RELEASE_ORDER}} 顺序)

```bash
git checkout {{INTEGRATION_BRANCH}}
git pull --ff-only origin {{INTEGRATION_BRANCH}}    # 失败 → conflict prompt §3,严禁 force-push
git merge --no-ff feat/<handle>-task____-<slug>
# 跑一遍该仓测试入口快速回归
git push origin {{INTEGRATION_BRANCH}}
git push origin feat/<handle>-task____-<slug>
```

## 3. 通讯收尾(Olympus 仓,一次 commit+push)

1. 任务文件:`status: merged`;补记:改动范围、冲突及解法、测试数字、文档清单、遗留欠账(无则写"无")。
2. 状态板:移入"最近完成",更新"接下来"。
3. **finish 信**发给受影响的成员(模板):

```markdown
---
from: <handle>
to: <handle>
date: <now>
re: TASK-____
needs_reply: no|yes
status: open
---
TASK-____ <标题> 已合并进 {{INTEGRATION_BRANCH}}。
- 合并 commit:<hash>(仓名)…
- 对你的影响:<新接口/契约字段/共享文件改动/无>
- 需要你做的:<merge 集成分支 / 会签 XX / 无>
- 测试:<真实数字>;冲突:<文件+采用语义,无则写无>
- 文档:<更新清单>;遗留:<欠账或风险,无则写无>
```

4. commit:`[<handle>] task: TASK-____ 完成并合并` → push。

## 4. 回到循环

需要发布验证 → (⚡ owner 侧)起草发布清单并提示手动执行;(其他人)finish 信里加"请 ⚡ 择机发布"。然后输出检查点报告(work-loop §3),**回到循环①**。
