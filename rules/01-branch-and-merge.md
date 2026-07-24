# rules/01 · 分支、checkout 与合并

> 适用于所有代码仓 `{{CODE_REPOS}}`。Olympus 仓自身单 main 分支直接提交(AGENTS.md §4)。

---

## 1. 分支模型

```
main / 稳定基线                ← 只接受来自集成分支的发布合并(集成者操作)
└─ {{INTEGRATION_BRANCH}}      ← ★唯一集成分支:所有任务分支汇入,环境从这里发布
     ├─ feat/<handle>-task<四位号>-<slug>
     ├─ fix/<handle>-task<四位号>-<slug>
     └─ chore/<handle>-...
```

- 集成分支全体代码仓统一命名;历史遗留分支在实例化时清点:合流或声明废弃,**不留第二条活跃集成线**。
- 一个任务(TASK-xxxx)在每个被触及的代码仓各开一条同名分支。

## 2. checkout 规则(开始一个任务)

```bash
git fetch origin
git checkout -b feat/<handle>-task<NNNN>-<slug> origin/{{INTEGRATION_BRANCH}}
```

- **必须从最新的远端集成分支出发**;不允许从本地旧分支或他人 feature 分支 checkout。
- 依赖他人未合并的代码:仍从集成分支 checkout,然后 merge 对方分支(见 §6),并在双方任务文件登记依赖。
- 同一任务返工回原分支;不为同一任务开第二条分支。

## 3. 开发中的 push / pull 节奏

- **push**:自己的任务分支随时可 push(备份+可见);至少每个工作日结束一次。
- **pull**:任务进行中不强制;但以下情况必须立即并入最新集成分支:①有人通知"契约变更已合入" ②即将改动共享文件 ③任务超过 3 个工作日。
- **禁止**:对已 push 的分支 rebase / force-push(本地未 push 前随意)。

## 4. 合并前置(缺一不可)

1. `git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}` —— 在**自己分支上**解掉全部冲突;
2. 全量测试绿(各仓测试入口在实例化时写进本节:`{{TEST_COMMANDS}}`),向人类报**真实数字**;
3. 任务文件更新 + finish 信写好(与合并一起 push);
4. **ack 检查**——触及以下任一项,先拿到对应 owner 的 `[ack]`(信件留痕,口头无效):
   - `contract/` 任何契约(端点形状、枚举字面量、事件名)→ 契约管家
   - 他人档案里声明的**独占区**文件 → 该 owner
   - 共享文件(各 pantheon 档案的共享区清单)→ 相关 owner
   - `contract/shared-resources.md` 登记的共享资源(migration 号等)→ 按占坑表
   - 鉴权/权限/安全语义 → 集成者
   - 你在他人权威领域写的代码(如开发者写了集成者领域的模块)→ 该领域 owner review

## 5. 合并操作(任务 owner 自己执行)

```bash
git checkout {{INTEGRATION_BRANCH}}
git pull --ff-only origin {{INTEGRATION_BRANCH}}   # 失败=本地集成分支被污染 → conflict prompt §3,严禁 force-push
git merge --no-ff feat/<handle>-task<NNNN>-<slug>  # --no-ff 保留任务边界
# 跑一遍该仓测试入口做快速回归
git push origin {{INTEGRATION_BRANCH}}
git push origin feat/<handle>-task<NNNN>-<slug>    # 任务分支保留追溯,定期清理
```

多仓任务按依赖顺序合并推送(实例化时定义:`{{RELEASE_ORDER}}`,与发布顺序一致,避免中间态不兼容)。合并完成后:push Olympus 仓的 finish 信 + 任务状态 + 状态板。

## 6. 拉取他人进展

| 场景 | 做法 |
|---|---|
| 对方已合入集成分支(常态) | `git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}` |
| 急需对方未合并的分支 | `git fetch origin feat/<对方>-taskXXXX-* && git merge origin/feat/<对方>-...`;**merge,禁止 cherry-pick**;双方任务文件登记依赖 + 发信告知 |
| 只看不并 | `git fetch` 后 `git log/diff`,或临时 `git worktree add` |

## 7. 冲突处理(详细流程见 prompts/conflict-and-integration.md)

1. 谁合并谁解。
2. 判定优先级:`contract/` > `plan/` 与 pantheon 所有权 > 对方任务文件与信件 > 代码注释。
3. 冲突落在**对方独占区** → 不擅自定夺:保留对方版本,发信问;拿不到 ack 就把自己的改动挪走。
4. **绝不**删除/注释对方的测试、断言、校验来"解决"冲突。
5. 共享资源撞号(migration 等)→ 后合并者改自己的,更新占坑表。
6. 解决后在 finish 信里写明:冲突文件 + 采用语义 + 理由。

## 8. 发布与 main(仅集成者/⚡ops owner,且全部手动)

- 发布源:集成分支;顺序 `{{RELEASE_ORDER}}`,回滚逆序;数据迁移只增不减。
- CI 触发 / 部署命令 / 基础设施:**⚡ owner 本人手动执行**;agent 只输出发布清单,并以「请 <owner> 手动执行」结尾。
- 发布结果发一封广播信(needs_reply: no)+ 更新状态板。
- 里程碑达成后由集成者把集成分支合入 `main` 并打 tag。

## 9. 速查卡

```bash
# 开始任务
git fetch origin && git checkout -b feat/<handle>-task<NNNN>-<slug> origin/{{INTEGRATION_BRANCH}}
# 日常备份
git push origin HEAD
# 吸收集成分支
git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}
# 结束任务(测试绿 + ack 后)
git checkout {{INTEGRATION_BRANCH}} && git pull --ff-only origin {{INTEGRATION_BRANCH}} \
  && git merge --no-ff <任务分支> && git push origin {{INTEGRATION_BRANCH}}
```
