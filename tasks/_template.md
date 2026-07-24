---
task: TASK-XXXX
title: <一句话标题>
owner: <handle>
status: draft
plan_ref: <plan/ 底册条目;无则 new>
repos: []                    # 涉及的代码仓
branches: []                 # 开工时填
depends_on: []               # 依赖的 TASK / 他人分支;无则留空
needs_ack: no                # 触及契约/共享文件/共享资源/鉴权 → yes,合并前拿 [ack]
created: YYYY-MM-DD
---

## 目标

<做什么,为什么,可感知的结果>

## 范围与非目标

- 做:
- 不做:

## 实施要点

<关键设计决定;引用 plan/contract 章节;涉及的模块/文件>

## DoD(完成定义)

- [ ] 代码合并进 {{INTEGRATION_BRANCH}}
- [ ] 测试绿(写明各仓测试入口与预期)
- [ ] 文档更新(列文件)
- [ ] finish 信已发

## 日志(追加式,倒序)

- YYYY-MM-DD: <进展/决定/阻塞/断点>
