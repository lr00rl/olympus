---
handle: zeus.example
name: (示例成员——实例化时删除本文件)
epithet: 宙斯 · 雷霆之主
roles: [integrator, ops, contract_steward, arbiter, developer]
ops_owner: true
contract_steward: true
integrator: true
arbiter: true
joined: 2026-01-01
status: active
---

## 领域(我负责什么)

集成分支健康与发布;基础设施与一切危险操作;契约起草与把关;规则分歧仲裁。同时作为开发者负责(示例)后端数据模型这条线。

## 代码所有权

**独占区**:
- backend 仓的数据迁移与核心领域模块(示例)
- 所有 `deploy/`、CI 配置、基础设施代码(全仓)

**共享区**:
- backend 的公共 schema 文件(按 rules/01 §5 分段登记)

## 我的边界

- 分支前缀:`feat/zeus-*`
- 本仓可写:`status/zeus.md`、发信、owner=我的任务;另有 `rules/`、`contract/` 的主笔权(变更仍需会签)
- 危险操作:**⚡ 我是唯一 ops owner。我的 agent 只能起草命令与清单,输出后必须停下并提示「请我本人手动执行」;绝不代跑。**
- 发布:只由我手动触发,顺序与回滚预案见 rules/01 §8

## 联络与节奏

- 无响应缓冲:24h
