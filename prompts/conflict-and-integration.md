# 神谕 · 冲突处理与拉取他人进展

---

## 1. 拉他人最新代码(在我的任务分支上)

```bash
# 常态:对方已合入集成分支
git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}

# 急用:对方分支未合并(merge,禁止 cherry-pick)
git fetch origin feat/<对方>-taskXXXX-<slug>
git merge origin/feat/<对方>-taskXXXX-<slug>
# → 双方任务文件登记依赖 + 发信告知
```

## 2. merge 冲突流程

1. `git status` 列冲突文件,**先分类再动手**:
   - **我的独占区**(我的 pantheon 档案):按我的任务语义解;
   - **他人独占区**:不擅自定夺——保留对方版本,把我的改动挪到我的文件/分段;确需改 → 发信拿 [ack],拿不到不合并;
   - **共享文件**:通常是分段追加造成的邻近行冲突,**union 保留双方**,按分段注释归位;
   - **契约相关**(枚举字面量、payload 字段):以 `contract/` 现行版本为准,谁不符改谁。
2. 判定优先级:`contract/` > `plan/` 与 pantheon 所有权 > 对方任务文件与信件 > 代码注释。
3. **红线**:绝不删除/注释对方的测试、断言、校验来消除冲突;共享资源撞号 → 后合并者改自己的并更新 `contract/shared-resources.md`。
4. 解决后:该仓全量测试 → 任务文件与 finish 信记录「冲突文件 + 采用语义 + 理由」。

## 3. 集成分支被污染(`git pull --ff-only` 失败)

```bash
git log --oneline origin/{{INTEGRATION_BRANCH}}..{{INTEGRATION_BRANCH}}   # 多了什么
```
- 多出的是**我自己的误提交**:`git branch backup/rescue-<date>` 备份 → `git reset --hard origin/{{INTEGRATION_BRANCH}}` → 把 rescue 的提交 merge 回我的任务分支;
- **看不懂/是别人的**:停下,发信 + 报告人类;**绝不 force-push、绝不擅自 reset 远端**。

## 4. 必须发信的冲突情形

- 冲突跨越所有权边界;
- 解冲突需要改已冻结的契约形状(→ 走变更单,等会签);
- 同一文件连续两个任务都冲突(所有权划分有问题,提议修订 pantheon 档案)。
