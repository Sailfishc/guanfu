# Artifact Extraction Gate v1

## Goal

The reader-facing tool must be extractable. A good artifact can be copied into a team doc, review meeting, product discussion, or personal checklist without the rest of the essay.

## Internal check

```text
Artifact title:
Artifact type:
Primary reader:
Decision it changes this week:
Where it appears:
Setup paragraph before artifact: yes/no
Interpretation after artifact: yes/no
Rows/checks are distinct: yes/no
Can copy into meeting doc: yes/no
```

## Hard failures

- The artifact only summarizes the article.
- Rows describe facts but do not change action.
- No primary reader can use it.
- The table needs the entire article to make sense.
- It appears suddenly with no setup or ends cold with no interpretation.

## Upgrade moves

| Weak artifact | Upgrade |
|---|---|
| `type / signal / action` | Add owner, default path, exit condition, or escalation trigger |
| Generic checklist | Tie each check to a specific decision or failure mode |
| Before/after table | Add “what to do this week” column |
| Failure list | Add detection signal and first response |
| Decision matrix | Add boundary case and when not to use it |

## Copyable formats

- 4-7 row decision table.
- 5-item checklist with pass/fail criteria.
- Failure-mode map with signal and response.
- Routing matrix with default owner and escalation trigger.
- Before/after workflow with what changes in the next meeting.
