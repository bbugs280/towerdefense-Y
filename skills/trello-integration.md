---
name: trello-integration
description: Add, move, and manage cards in Trello My Tasks board
metadata:
  openclaw:
    requires:
      env:
        - TRELLO_API_KEY
        - TRELLO_TOKEN
---

# Trello Integration Skill

## Board: My Tasks
**Board ID:** 592bea13ea99704150413f0a

## Available Lists (12 total)

### Time-Based
1. **Today** — Tasks for today
2. **Regular (daily, weekly, monthly)** — Recurring tasks and habits

### Status-Based
3. **In process** — Currently working on
4. **blocked/waiting** — Blocked or waiting on dependencies
5. **Done** — Completed tasks

### Categorized
6. **To do** — General tasks (default if unclear)
7. **Inbox** — Quick captures, uncategorized items (default for unclear captures)
8. **Idea** — Project ideas, concepts, brainstorms
9. **Habits/Goals** — Goals, objectives, and habit tracking
10. **To Buy** — Shopping list, procurement items
11. **To learn or Try** — Learning resources, courses, experiments
12. **Planner** — Scheduled items with specific dates

## Operations

### Create Card
Create a new card in specified list
```bash
curl -X POST https://api.trello.com/1/cards \
  -d "idList=[LIST_ID]" \
  -d "name=[CARD_TITLE]" \
  -d "desc=[DESCRIPTION]" \
  -d "key=$TRELLO_API_KEY" \
  -d "token=$TRELLO_TOKEN"
```

### Move Card
Move card between lists
```bash
curl -X PUT https://api.trello.com/1/cards/[CARD_ID] \
  -d "idList=[NEW_LIST_ID]" \
  -d "key=$TRELLO_API_KEY" \
  -d "token=$TRELLO_TOKEN"
```

### Add Comment
Add comment to card
```bash
curl -X POST https://api.trello.com/1/cards/[CARD_ID]/actions/comments \
  -d "text=[COMMENT_TEXT]" \
  -d "key=$TRELLO_API_KEY" \
  -d "token=$TRELLO_TOKEN"
```

### Archive Card
Archive card
```bash
curl -X PUT https://api.trello.com/1/cards/[CARD_ID] \
  -d "closed=true" \
  -d "key=$TRELLO_API_KEY" \
  -d "token=$TRELLO_TOKEN"
```

## Task Inference Rules

**Time References:**
- "today", "this morning", "tonight" → **Today**
- "every day", "weekly", "monthly" → **Regular**
- "in progress", "working on" → **In process**
- "waiting", "blocked", "pending" → **blocked/waiting**
- "done", "completed", "finished" → **Done**

**Categories:**
- "buy", "shopping", "get milk" → **To Buy**
- "learn", "course", "tutorial", "try" → **To learn or Try**
- "idea", "concept", "startup", "project" → **Idea**
- "goal", "habit", "objective" → **Habits/Goals**
- "schedule", "plan", "meeting", "[specific date]" → **Planner**
- unclear or no context → **Inbox** or **To do**

## Notes
- Default list if ambiguous: **Inbox** (for capture), **To do** (for tasks)
- Always confirm action with user
- Personal-assistant agent uses this skill for all Trello operations
