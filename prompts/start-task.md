# 神谕 · 开始一个任务

> 工作循环第③步。agent 自行遵循;人类也可粘贴使用:「现在开始 TASK-____,按 start-task 走」。

---

现在开始任务 **TASK-____**。逐步执行,每步给人类看结果:

1. **同步**:Olympus 仓 `git pull --rebase origin main`;播报有无影响本任务的新信息(契约变更/对方在改的共享文件/阻塞)。
2. **核对任务文件**:打开 `tasks/TASK-____*.md`;没有就从 `_template.md` 创建(owner=我,底册引用 plan/ 对应条目)。确认:目标、涉及仓、DoD、依赖——依赖未就绪且无法 mock → 换任务。
3. **占坑检查**(涉及则做):共享资源(migration 号/枚举/端口/事件名)→ `contract/shared-resources.md` 登记;新接口 → 确认 `contract/api-contract.md` 已有形状,没有则(契约管家)先补契约 /(其他人)发信申请。
4. **开分支**(每个涉及的代码仓):
   ```bash
   git fetch origin
   git checkout -b feat/<handle>-task____-<slug> origin/{{INTEGRATION_BRANCH}}
   ```
5. **登记开工**(Olympus 仓一次 commit+push):任务文件 `status: in_progress` + 分支名;状态板更新;需要他人配合的事**现在就发信**(别等卡住才发)。commit:`[<handle>] task: TASK-____ 开工`。
6. **列施工计划**:拆成可验证的小步(一步一个 commit 粒度),说明测试策略,人类确认后进入施工。

施工中持续遵守:小步 commit;不碰他人独占区;触及共享文件前先 fetch 集成分支;(⚡ owner 侧)危险命令只起草;散文不等于完成。
