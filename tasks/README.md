# tasks/ · 命运三女神(任务档案)

> 一任务一文件:`TASK-<四位号>-<slug>.md`。编号全局递增,谁创建谁占号(撞号后 push 者 +1 改名)。
> owner 独占正文;他人意见走信,owner 采纳后自己改。`plan/` 是任务底册,TASK 文件是执行期唯一真值。

## 状态机(纺线 → 量线 → 剪线)

```
draft(纺) → ready(可开工) → in_progress(量) → done(代码完成待合并) → merged(剪断,善终)
                                  ↓ ↑
                                blocked(写明卡在哪)        任何态 → cancelled(写原因)
```

## 任务索引(新建/变更状态时手工维护;向导会生成首批)

| TASK | 标题 | Owner | 状态 | 底册 |
|---|---|---|---|---|
| 0001 | (示例)见 TASK-0001.example.md,实例化时删除 | athena.example | ready | plan/… |
