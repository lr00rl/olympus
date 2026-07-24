---
handle: athena.example
name: (示例成员——实例化时删除本文件)
epithet: 雅典娜 · 织造与智略
roles: [developer, reviewer]
ops_owner: false
contract_steward: false
integrator: false
arbiter: false
joined: 2026-01-01
status: active
---

## 领域(我负责什么)

(示例)前端与工作台体验这条线:页面、组件、信息架构;兼跨线 reviewer。

## 代码所有权

**独占区**:
- front 仓的页面与组件目录(示例)
- 我在 backend 新建的独立模块(示例;完成后请 zeus review)

**共享区**:
- front 的公共 hooks/types 文件(按 rules/01 §5 分段登记)

## 我的边界

- 分支前缀:`feat/athena-*`
- 本仓可写:`status/athena.md`、发信、owner=我的任务
- **危险操作:零接触。** 不执行也不起草;不修改 deploy/CI/基础设施文件。需要环境、发布、服务器日志 → 写信给 ⚡ zeus,然后换任务继续,不空等。
- 我写的 backend 代码需 zeus review 后才能合入集成分支

## 联络与节奏

- 无响应缓冲:24h
