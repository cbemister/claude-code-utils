---
name: team-battle
description: Run two agent teams head-to-head on the same task. Creates parallel worktrees, installs different team agents in each, runs the task, and compares results side-by-side.
args: "[task] - The task description both teams will execute"
---

# Team Battle

Run two agent teams head-to-head on the same task using git worktrees, then compare results.

## Instructions

### Phase 1: Setup

1. **Parse the task argument.** If no task was provided, ask the user:
   ```
   What task should both teams work on?
   Example: "Build a user settings page with profile editing"
   ```

2. **Load available teams.** Find `teams.json` from:
   - `~/.claude/shared/enterprise/teams/teams.json`
   - `~/.claude/skills/enhance-app/templates/enhance-app/teams/teams.json`
   - Or relative to this skill's location: `../../skills/enhance-app/templates/enhance-app/teams/teams.json`

   If not found, check if `templates/enhance-app/teams/teams.json` exists in the current repo.

3. **Present team selection for Team A:**
   ```
   Select Team A:

     1. Enterprise Engineering — 7 agents, no design
     2. SaaS Product — 8 agents, UI/UX + conversion
     3. Internal Tool — 8 agents, UI/UX (practical)
     4. Game / Interactive — 6 agents, UI/UX + mobile
     5. Marketing Site — 6 agents, all 3 designers

   Team A (1-5):
   ```

4. **Present team selection for Team B** (exclude Team A's choice from recommendations but allow it):
   ```
   Select Team B (competing against [Team A name]):
   ...
   Team B (1-5):
   ```

### Phase 2: Provision Worktrees

1. **Create two worktrees** from the current branch:
   ```bash
   BRANCH_A="battle/team-a-$(date +%s)"
   BRANCH_B="battle/team-b-$(date +%s)"

   git worktree add "../$(basename $PWD)-team-a" -b "$BRANCH_A"
   git worktree add "../$(basename $PWD)-team-b" -b "$BRANCH_B"
   ```

2. **Install Team A's agents** in worktree A:
   - Create `.claude/agents/` in the worktree
   - Copy the Team A coordinator from `teams/$TEAM_A_ID/coordinator.md`
   - Copy each agent listed in Team A's `agents` array from the shared agent pool

3. **Install Team B's agents** in worktree B:
   - Same process with Team B's configuration

4. **Report:**
   ```
   Worktrees created:
     Team A ([name]): ../project-team-a/ — [N] agents installed
     Team B ([name]): ../project-team-b/ — [N] agents installed
   ```

### Phase 3: Execute

Launch two agents in parallel using the Agent tool — one targeting each worktree. Each agent receives:

```
You are working in a project with the [TEAM_NAME] agent team installed.
Your team consists of: [list of agents from teams.json].

Task: [THE TASK FROM PHASE 1]

Instructions:
1. Use the coordinator agent pattern — delegate to your specialist agents
2. Read .claude/rules/ if they exist to understand the project
3. Implement the task fully — write code, create components, handle edge cases
4. When done, summarize what you built and what files were created/modified
```

**IMPORTANT:** Set the working directory for each agent to its respective worktree path.

Wait for both agents to complete.

### Phase 4: Compare

1. **Gather results from both worktrees:**
   ```bash
   # Team A changes
   cd "../$(basename $PWD)-team-a"
   git diff --stat HEAD
   git diff HEAD

   # Team B changes
   cd "../$(basename $PWD)-team-b"
   git diff --stat HEAD
   git diff HEAD
   ```

2. **Present comparison report:**
   ```markdown
   # Team Battle Results

   ## Task
   [The task that was given to both teams]

   ## Team A: [Name] ([N] agents)
   ### Files Changed
   - [file list with +/- lines]

   ### Approach Summary
   [Summary of Team A's approach based on their output]

   ### Strengths
   - [What Team A did well]

   ### Weaknesses
   - [What Team A missed or did poorly]

   ---

   ## Team B: [Name] ([N] agents)
   ### Files Changed
   - [file list with +/- lines]

   ### Approach Summary
   [Summary of Team B's approach]

   ### Strengths
   - [What Team B did well]

   ### Weaknesses
   - [What Team B missed or did poorly]

   ---

   ## Head-to-Head Comparison

   | Aspect | Team A | Team B |
   |--------|--------|--------|
   | Files created | [N] | [N] |
   | Lines of code | [N] | [N] |
   | Design quality | [rating] | [rating] |
   | Code quality | [rating] | [rating] |
   | Completeness | [rating] | [rating] |
   | Performance | [rating] | [rating] |

   ## Recommendation
   [Which team produced better results for this task and why]
   ```

### Phase 5: Resolve

Ask the user what to do with the results:

```
What would you like to do?

  1. Keep Team A's work — merge into current branch, cleanup Team B
  2. Keep Team B's work — merge into current branch, cleanup Team A
  3. Cherry-pick from both — I'll review and pick specific changes
  4. Keep both worktrees — I'll review manually later
  5. Discard both — clean up everything
```

**For option 1 or 2 (keep winner):**
```bash
# Merge winner's changes
cd /path/to/original/project
git merge --no-ff "$WINNING_BRANCH" -m "feat: [task summary] (team battle winner: [team name])"

# Cleanup
git worktree remove "../project-team-a"
git worktree remove "../project-team-b"
git branch -d "$BRANCH_A" "$BRANCH_B"
```

**For option 3 (cherry-pick):**
```
Both worktrees are preserved at:
  Team A: ../project-team-a/
  Team B: ../project-team-b/

Use git cherry-pick or manually copy files. When done, run:
  git worktree remove "../project-team-a"
  git worktree remove "../project-team-b"
```

**For option 4 (keep both):**
```
Worktrees preserved:
  Team A: ../project-team-a/ (branch: $BRANCH_A)
  Team B: ../project-team-b/ (branch: $BRANCH_B)

Review at your leisure. Clean up when done:
  git worktree remove "../project-team-a"
  git worktree remove "../project-team-b"
```

**For option 5 (discard):**
```bash
git worktree remove "../project-team-a"
git worktree remove "../project-team-b"
git branch -D "$BRANCH_A" "$BRANCH_B"
echo "Both worktrees cleaned up."
```

## Notes

- Each team works independently — they cannot see each other's work
- The task prompt is identical for both teams
- Results are compared on: code quality, design quality, completeness, and approach
- This is useful for finding which team composition works best for your project type
- You can run multiple battles to build intuition about team strengths
