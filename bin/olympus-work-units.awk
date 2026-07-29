#!/usr/bin/awk -f
# Parse the deliberately small work_units/v1 YAML subset used by Olympus task frontmatter.
#
# Input fields inside work_units must stay on one line. This keeps the optional CLI dependency-free
# while task files remain ordinary Markdown/YAML that richer runtimes can parse normally.

function trim(value) {
  sub(/^[[:space:]]+/, "", value)
  sub(/[[:space:]]+$/, "", value)
  return value
}

function scalar(line) {
  sub(/^[^:]+:[[:space:]]*/, "", line)
  sub(/[[:space:]]+#.*$/, "", line)
  return trim(line)
}

function inline_list(value, field, ref) {
  value = trim(value)
  if (value !~ /^\[.*\]$/) {
    invalid(ref ": " field " must be an inline list, for example [] or [TASK-0001#slice]")
    return value
  }
  sub(/^\[/, "", value)
  sub(/\]$/, "", value)
  gsub(/[[:space:]]*,[[:space:]]*/, ",", value)
  return trim(value)
}

function invalid(message) {
  validation[++validation_count] = message
}

function reset_unit() {
  current_unit_id = ""
  current_unit_title = ""
  current_unit_owner = ""
  current_unit_status = ""
  current_unit_start_after = "[]"
  current_unit_merge_after = "[]"
  current_unit_repos = "[]"
  current_unit_resources = "[]"
  current_unit_needs_ack = "no"
  current_unit_human_only = "no"
  current_unit_decision_gate = ""
}

function add_unit(is_legacy, ref) {
  if (current_unit_id == "") {
    if (!is_legacy) {
      invalid(current_file ": work unit without id")
    }
    return
  }

  ref = current_task_id "#" current_unit_id
  if (ref in unit_file) {
    invalid(current_file ": duplicate work unit " ref)
    reset_unit()
    return
  }

  if (current_unit_id !~ /^[a-z0-9][a-z0-9._-]*$/) {
    invalid(current_file ": invalid work unit id '" current_unit_id "'")
  }
  if (current_unit_status !~ /^(draft|ready|in_progress|done|merged|blocked|cancelled)$/) {
    invalid(current_file ": " ref " has illegal status '" current_unit_status "'")
  }
  if (current_unit_needs_ack !~ /^(yes|no)$/) {
    invalid(current_file ": " ref " needs_ack must be yes or no")
  }
  if (current_unit_human_only !~ /^(yes|no)$/) {
    invalid(current_file ": " ref " human_only must be yes or no")
  }

  unit_order[++unit_count] = ref
  task_unit_count[current_task_id]++
  task_unit[current_task_id SUBSEP task_unit_count[current_task_id]] = ref
  unit_task[ref] = current_task_id
  unit_file[ref] = current_file
  unit_title[ref] = current_unit_title != "" ? current_unit_title : current_task_title
  if (current_unit_owner != "" && current_unit_owner != current_task_owner) {
    invalid(current_file ": " ref " owner must match task owner; split cross-seat work into its own task")
  }
  unit_owner[ref] = current_task_owner
  unit_status[ref] = current_unit_status
  unit_start_after[ref] = is_legacy ? current_task_depends_on : inline_list(current_unit_start_after, "start_after", ref)
  unit_merge_after[ref] = is_legacy ? "" : inline_list(current_unit_merge_after, "merge_after", ref)
  unit_repos[ref] = is_legacy ? inline_list(current_task_repos, "repos", ref) : inline_list(current_unit_repos, "repos", ref)
  if (unit_repos[ref] == "") {
    unit_repos[ref] = inline_list(current_task_repos, "repos", ref)
  }
  unit_resources[ref] = is_legacy ? "" : inline_list(current_unit_resources, "resources", ref)
  unit_needs_ack[ref] = is_legacy ? current_task_needs_ack : current_unit_needs_ack
  unit_human_only[ref] = is_legacy ? "no" : current_unit_human_only
  unit_decision_gate[ref] = is_legacy ? current_task_blocked_by_ruling : current_unit_decision_gate
  unit_is_legacy[ref] = is_legacy
  reset_unit()
}

function finish_task() {
  if (current_task_id == "") {
    return
  }

  if (current_task_id in task_file) {
    invalid(current_file ": duplicate task id " current_task_id)
  }
  task_order[++task_count] = current_task_id
  task_file[current_task_id] = current_file
  task_title[current_task_id] = current_task_title
  task_owner[current_task_id] = current_task_owner
  task_status[current_task_id] = current_task_status

  if (has_work_units) {
    if (current_task_schema != "work-units/v1") {
      invalid(current_file ": work_units requires task_schema: work-units/v1")
    }
    add_unit(0)
    if (units_in_current_task == 0) {
      invalid(current_file ": work_units declared but no units found")
    }
  } else {
    if (current_task_schema == "work-units/v1") {
      invalid(current_file ": task_schema work-units/v1 requires work_units")
    }
    current_unit_id = "default"
    current_unit_title = current_task_title
    current_unit_owner = current_task_owner
    current_unit_status = current_task_status
    add_unit(1)
  }
}

function reset_task() {
  current_file = FILENAME
  current_task_id = ""
  current_task_schema = ""
  current_task_title = ""
  current_task_owner = ""
  current_task_status = ""
  current_task_depends_on = ""
  current_task_repos = "[]"
  current_task_needs_ack = "no"
  current_task_blocked_by_ruling = ""
  has_work_units = 0
  units_in_current_task = 0
  in_frontmatter = 0
  in_work_units = 0
  delimiter_count = 0
  reset_unit()
}

function split_refs(value, refs, count, i, item) {
  value = trim(value)
  if (value == "" || value == "-") {
    return 0
  }
  count = split(value, refs, ",")
  for (i = 1; i <= count; i++) {
    item = trim(refs[i])
    refs[i] = item
  }
  return count
}

function reference_exists(reference) {
  if (reference ~ /#/) {
    return reference in unit_file
  }
  return reference in task_file
}

function reference_done(reference) {
  if (reference ~ /#/) {
    return unit_status[reference] == "done" || unit_status[reference] == "merged"
  }
  return task_status[reference] == "done" || task_status[reference] == "merged"
}

function blockers_for(ref, refs, count, i, dependency, blockers, writer_key) {
  blockers = ""
  if (unit_owner[ref] == "" || unit_owner[ref] == "unassigned" || unit_owner[ref] == "<handle>") {
    blockers = "owner:unassigned"
  }
  if (unit_status[ref] == "blocked") {
    blockers = blockers (blockers == "" ? "" : ",") "status:blocked"
  }
  if (unit_human_only[ref] == "yes") {
    blockers = blockers (blockers == "" ? "" : ",") "human_only"
  }
  if (unit_decision_gate[ref] != "" && unit_decision_gate[ref] != "-" && unit_decision_gate[ref] != "—" && unit_decision_gate[ref] != "none" && unit_decision_gate[ref] != "\"\"") {
    blockers = blockers (blockers == "" ? "" : ",") "decision:" unit_decision_gate[ref]
  }
  count = split_refs(unit_start_after[ref], refs)
  for (i = 1; i <= count; i++) {
    dependency = refs[i]
    if (!reference_done(dependency)) {
      blockers = blockers (blockers == "" ? "" : ",") dependency
    }
  }
  count = split_refs(unit_repos[ref], refs)
  for (i = 1; i <= count; i++) {
    dependency = refs[i]
    writer_key = dependency SUBSEP unit_owner[ref]
    if (repo_writer_count[dependency] >= 3 && !(writer_key in active_writer)) {
      blockers = blockers (blockers == "" ? "" : ",") "repo_capacity:" dependency
    }
  }
  count = split_refs(unit_resources[ref], refs)
  for (i = 1; i <= count; i++) {
    dependency = refs[i]
    if ((dependency in active_resource) && active_resource[dependency] != ref) {
      blockers = blockers (blockers == "" ? "" : ",") "resource:" dependency
    }
  }
  return blockers
}

function index_active_work(ref, refs, count, i, value, writer_key) {
  if (unit_status[ref] != "in_progress" || task_status[unit_task[ref]] !~ /^(ready|in_progress)$/) {
    return
  }
  if (unit_owner[ref] != "" && unit_owner[ref] != "unassigned" && unit_owner[ref] != "<handle>") {
    active_seat[unit_owner[ref]] = ref
  }
  count = split_refs(unit_repos[ref], refs)
  for (i = 1; i <= count; i++) {
    value = refs[i]
    writer_key = value SUBSEP unit_owner[ref]
    if (!(writer_key in active_writer)) {
      active_writer[writer_key] = ref
      repo_writer_count[value]++
      repo_seen[value] = 1
    }
  }
  count = split_refs(unit_resources[ref], refs)
  for (i = 1; i <= count; i++) {
    value = refs[i]
    if (!(value in active_resource)) {
      active_resource[value] = ref
    } else {
      invalid("exclusive resource '" value "' is active in both " active_resource[value] " and " ref)
    }
  }
}

function validate_references(ref, field, value, refs, count, i, dependency) {
  if (unit_is_legacy[ref]) {
    return
  }
  count = split_refs(value, refs)
  for (i = 1; i <= count; i++) {
    dependency = refs[i]
    if (dependency !~ /^TASK-[0-9][0-9][0-9][0-9](#[a-z0-9][a-z0-9._-]*)?$/) {
      invalid(unit_file[ref] ": " ref " " field " has invalid reference '" dependency "'")
    } else if (!reference_exists(dependency)) {
      invalid(unit_file[ref] ": " ref " " field " references unknown '" dependency "'")
    }
  }
}

function node_file(node) {
  return node ~ /#/ ? unit_file[node] : task_file[node]
}

function visit(node, refs, count, i, dependency) {
  visit_state[node] = 1
  if (node ~ /#/) {
    count = split_refs(unit_start_after[node], refs)
    for (i = 1; i <= count; i++) {
      dependency = refs[i]
      if (!reference_exists(dependency)) {
        continue
      }
      if (visit_state[dependency] == 1) {
        invalid(node_file(node) ": development dependency cycle includes " node " -> " dependency)
      } else if (visit_state[dependency] == 0) {
        visit(dependency)
      }
    }
  } else {
    count = task_unit_count[node]
    for (i = 1; i <= count; i++) {
      dependency = task_unit[node SUBSEP i]
      if (visit_state[dependency] == 1) {
        invalid(node_file(node) ": development dependency cycle includes " node " -> " dependency)
      } else if (visit_state[dependency] == 0) {
        visit(dependency)
      }
    }
  }
  visit_state[node] = 2
}

function owner_matches(ref) {
  return handle == "*" || unit_owner[ref] == handle
}

function frontier_blockers_for(ref, blockers, owner) {
  blockers = blockers_for(ref)
  owner = unit_owner[ref]
  if (owner != "" && owner != "unassigned" && owner != "<handle>" && owner in active_seat) {
    blockers = blockers (blockers == "" ? "" : ",") "seat_capacity:" owner
  }
  return blockers
}

function reserve_frontier(ref, refs, count, i, value, writer_key, owner) {
  owner = unit_owner[ref]
  if (owner != "" && owner != "unassigned" && owner != "<handle>") {
    active_seat[owner] = ref
  }
  count = split_refs(unit_repos[ref], refs)
  for (i = 1; i <= count; i++) {
    value = refs[i]
    writer_key = value SUBSEP owner
    if (!(writer_key in active_writer)) {
      active_writer[writer_key] = ref
      repo_writer_count[value]++
    }
  }
  count = split_refs(unit_resources[ref], refs)
  for (i = 1; i <= count; i++) {
    active_resource[refs[i]] = ref
  }
}

function emit_inventory(ref, category, blockers) {
  print category "\t" ref "\t" unit_file[ref] "\t" unit_owner[ref] "\t" unit_title[ref] "\t" blockers "\t" unit_merge_after[ref] "\t" unit_repos[ref] "\t" unit_resources[ref] "\t" unit_needs_ack[ref] "\t" unit_human_only[ref]
}

FNR == 1 {
  reset_task()
}

$0 == "---" {
  delimiter_count++
  if (delimiter_count == 1) {
    in_frontmatter = 1
  } else if (delimiter_count == 2) {
    in_frontmatter = 0
    finish_task()
  }
  next
}

in_frontmatter {
  line = $0
  if (in_work_units && line !~ /^  /) {
    in_work_units = 0
  }

  if (line ~ /^work_units:[[:space:]]*$/) {
    has_work_units = 1
    in_work_units = 1
    next
  }

  if (in_work_units) {
    if (line ~ /^  - id:[[:space:]]*/) {
      if (current_unit_id != "") {
        add_unit(0)
      }
      units_in_current_task++
      current_unit_id = scalar(line)
    } else if (line ~ /^    title:/) {
      current_unit_title = scalar(line)
    } else if (line ~ /^    owner:/) {
      current_unit_owner = scalar(line)
    } else if (line ~ /^    status:/) {
      current_unit_status = scalar(line)
    } else if (line ~ /^    start_after:/) {
      current_unit_start_after = scalar(line)
    } else if (line ~ /^    merge_after:/) {
      current_unit_merge_after = scalar(line)
    } else if (line ~ /^    repos:/) {
      current_unit_repos = scalar(line)
    } else if (line ~ /^    resources:/) {
      current_unit_resources = scalar(line)
    } else if (line ~ /^    needs_ack:/) {
      current_unit_needs_ack = scalar(line)
    } else if (line ~ /^    human_only:/) {
      current_unit_human_only = scalar(line)
    } else if (line ~ /^    decision_gate:/) {
      current_unit_decision_gate = scalar(line)
    }
    next
  }

  if (line ~ /^task:/) current_task_id = scalar(line)
  else if (line ~ /^task_schema:/) current_task_schema = scalar(line)
  else if (line ~ /^title:/) current_task_title = scalar(line)
  else if (line ~ /^owner:/) current_task_owner = scalar(line)
  else if (line ~ /^status:/) current_task_status = scalar(line)
  else if (line ~ /^depends_on:/) current_task_depends_on = inline_list(scalar(line), "depends_on", current_file)
  else if (line ~ /^repos:/) current_task_repos = scalar(line)
  else if (line ~ /^needs_ack:/) current_task_needs_ack = scalar(line)
  else if (line ~ /^blocked_by_ruling:/) current_task_blocked_by_ruling = scalar(line)
}

END {
  for (i = 1; i <= unit_count; i++) {
    index_active_work(unit_order[i])
  }
  for (repo in repo_seen) {
    if (repo_writer_count[repo] > 3) {
      invalid("repo '" repo "' has " repo_writer_count[repo] " concurrent writers (maximum 3)")
    }
  }
  for (i = 1; i <= unit_count; i++) {
    ref = unit_order[i]
    if (unit_status[ref] == "in_progress" && task_status[unit_task[ref]] != "in_progress") {
      invalid(unit_file[ref] ": " ref " is in_progress but task " unit_task[ref] " is not")
    }
    if (task_status[unit_task[ref]] == "done" && unit_status[ref] !~ /^(done|merged|cancelled)$/) {
      invalid(unit_file[ref] ": task " unit_task[ref] " is done before " ref)
    }
    if (task_status[unit_task[ref]] == "merged" && unit_status[ref] !~ /^(merged|cancelled)$/) {
      invalid(unit_file[ref] ": task " unit_task[ref] " is merged before " ref)
    }
    validate_references(ref, "start_after", unit_start_after[ref])
    validate_references(ref, "merge_after", unit_merge_after[ref])
  }
  for (i = 1; i <= task_count; i++) {
    ref = task_order[i]
    if (visit_state[ref] == 0) {
      visit(ref)
    }
  }

  if (mode == "doctor") {
    for (i = 1; i <= validation_count; i++) {
      print "RED\t" validation[i]
    }
  }

  for (i = 1; i <= unit_count; i++) {
    ref = unit_order[i]
    if (task_status[unit_task[ref]] !~ /^(ready|in_progress)$/) {
      continue
    }
    blockers = mode == "frontier" ? frontier_blockers_for(ref) : blockers_for(ref)
    if (unit_status[ref] == "in_progress") {
      if ((mode == "inventory" || mode == "frontier") && owner_matches(ref)) emit_inventory(ref, "IN_PROGRESS", "")
    } else if (unit_status[ref] == "ready" && blockers == "") {
      if ((mode == "inventory" || mode == "frontier") && owner_matches(ref)) emit_inventory(ref, "RUNNABLE", "")
      if (mode == "frontier") reserve_frontier(ref)
    } else if ((unit_status[ref] == "ready" || unit_status[ref] == "blocked") && blockers != "") {
      if ((mode == "inventory" || mode == "frontier") && owner_matches(ref)) emit_inventory(ref, "WAITING", blockers)
    }
  }
}
