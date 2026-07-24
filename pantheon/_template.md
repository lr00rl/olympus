---
handle: <小写英文,如 hermes>
name: <称呼/真名可选>
epithet: <神格,可选,纯趣味>
roles: [developer]            # 见 README 角色词表;可多个
ops_owner: false              # ⚡ 危险操作执行权(整个山上尽量只有一人为 true)
contract_steward: false
integrator: false
arbiter: false
joined: YYYY-MM-DD
status: active                # active | away | left
---

## 领域(我负责什么)

<一句话 + 展开;对应项目规划中的哪条线>

## 代码所有权

**独占区**(别人不改;要改先发消息拿我 ack):
- <repo>/<路径或模块> …

**共享区**(我常碰、按 rules/01 §5 需登记的):
- <repo>/<文件> …

## 我的边界

- 分支前缀:`feat/<handle>-*`
- 本仓可写:`status/<handle>.md`、`messages/inbox/*/`(发信)、owner=我的 `tasks/*`
- 危险操作:<无 | ⚡我是 ops owner:agent 只起草,我本人手动执行>
- 其他约定:<如"我的 backend 代码需 <谁> review 后合并">

## 联络与节奏

- 时区/常在线时段:<可选>
- 无响应缓冲:24h(默认,可改)
