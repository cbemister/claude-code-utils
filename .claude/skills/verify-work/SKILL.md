---
name: verify-work
description: Comprehensive pre-commit verification for security, best practices, code standards, and performance. Checks for vulnerabilities, efficiency issues, N+1 queries, and convention adherence.
---

# Verify Work Skill

Comprehensive pre-commit verification of code changes for security vulnerabilities, best practices violations, efficiency issues, and code standards adherence. Works with any project.

## When to Use

- Invoked automatically as Phase 0 of `/ship` (mandatory)
- Can also be invoked manually with `/verify-work` to check changes before committing

## Behavior

- **Non-interactive**: Runs all checks, auto-fixes what it can, and reports remaining issues
- **No prompts**: Does not ask for input — just fixes and reports
- **Universal**: Works with any TypeScript/JavaScript project

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Run every phase to completion without pausing. Never ask questions, request confirmation, offer choices, or wait for input at any point. Auto-fix what you can silently. Report everything at the end. Do not stop early even if blocking issues are found.

### Phase 1: Analyze Changed Files

**Goal**: Get comprehensive view of all changes

```bash
# Get changed file list
git status --short

# Get diff statistics
git diff --stat HEAD

# Get detailed diff
git diff HEAD

# Get file paths only
git diff --name-only HEAD
```

---

### Phase 2: Security Checks [BLOCKING]

#### 2.1 Hardcoded Secrets Detection

```bash
# Check for potential secrets
git diff HEAD | grep -iE "(password|secret|api[_-]?key|token|stripe[_-]?key|jwt[_-]?secret|database[_-]?url).*=.*['\"]" | grep -v "process\.env"

# Check for actual secret patterns (32+ character strings)
git diff HEAD | grep -E "^[+].*['\"][a-zA-Z0-9_-]{32,}['\"]"

# Check for .env files (should never be committed)
git diff --name-only HEAD | grep -E "^\.env"
```

**Flag if found**:
- BLOCKING: Any hardcoded credentials (passwords, API keys, tokens)
- BLOCKING: Database URLs with credentials
- BLOCKING: Any `.env` or `.env.local` files

#### 2.2 SQL Injection Risks

```bash
# Check for template literal variables in SQL queries
git diff HEAD -- '**/*.ts' '**/*.tsx' | grep -E "\`.*\$\{.*\}.*\`" | grep -iE "select|insert|update|delete|where"

# Check for string concatenation in queries
git diff HEAD -- '**/*.ts' '**/*.tsx' | grep -E "query\(.*\+|sql\(.*\+"
```

**Flag if found**:
- BLOCKING: Template literals with variables in SQL queries
- BLOCKING: String concatenation in query building

#### 2.3 XSS Vulnerabilities

```bash
# Check for dangerouslySetInnerHTML
git diff HEAD -- '**/*.tsx' | grep -E "dangerouslySetInnerHTML|innerHTML"
```

**Flag if found**:
- BLOCKING: Any use of `dangerouslySetInnerHTML` without explicit justification

#### 2.4 Missing Input Validation

```bash
# Check for request.json() without validation
git diff HEAD -- '**/*.ts' | grep "request\.json()" -A 3 | grep -v "safeParse\|parse\|schema\|validate"
```

**Flag if found**:
- BLOCKING: API routes accepting JSON input without validation

---

### Phase 3: Best Practices Review [BLOCKING]

#### 3.1 Debug Code Removal

```bash
# Find console statements in changed files
git diff HEAD | grep -nE "^[+].*console\.(log|warn|error|info|debug)" | grep -v "// console"

# Find TODO/FIXME comments
git diff HEAD | grep -niE "^[+].*(//)?\s*(todo|fixme|xxx|hack)"

# Find commented-out code blocks (3+ consecutive lines)
git diff HEAD | grep -E "^[+]\s*//\s*[a-zA-Z]" -A 2 | grep -E "^[+]\s*//"
```

**Flag if found**:
- BLOCKING: `console.log` statements (except in error boundaries/handlers)
- WARNING: TODO/FIXME comments without tracking
- WARNING: Large blocks of commented code (3+ lines)

**Auto-fix**: Remove console.log/warn/info/debug statements automatically. Keep console.error in catch blocks.

#### 3.2 TypeScript Issues

```bash
# Find 'any' types
git diff HEAD -- '*.ts' '*.tsx' | grep -nE ":\s*any[^a-zA-Z]" | grep -v "// "

# Find @ts-ignore or @ts-nocheck
git diff HEAD | grep -nE "@ts-(ignore|nocheck|expect-error)"
```

**Flag if found**:
- BLOCKING: `: any` type annotations
- BLOCKING: `@ts-ignore` without explanation comment

#### 3.3 Error Handling

```bash
# Check for empty catch blocks
git diff HEAD -- '**/*.ts' '**/*.tsx' | grep -E "catch.*\{" -A 5 | grep -E "^[+]\s*\}"
```

**Flag if found**:
- BLOCKING: Empty catch blocks
- BLOCKING: Catch blocks that swallow errors silently

---

### Phase 4: Efficiency Review [OPTIMIZATION]

#### 4.1 React Hook Issues

```bash
# Check for useEffect without dependency array
git diff HEAD -- '**/*.tsx' | grep "useEffect" -A 2 | grep -E "^\+.*\}\)" | grep -v ", \["
```

**Flag if found**:
- WARNING: `useEffect` without dependency array (infinite loop risk)

#### 4.2 Import Optimization

```bash
# Check for potentially unused imports
git diff HEAD | grep "^+import" | cut -d' ' -f2 | cut -d',' -f1 | while read import; do
  git diff HEAD | grep -v "^+import" | grep -q "$import" || echo "Potentially unused: $import"
done
```

**Flag if found**:
- WARNING: Imports added but not used in changes

#### 4.3 Code Complexity & File Size

```bash
# Find large files (500+ lines) in changed files
git diff --name-only HEAD | while read file; do
  if [ -f "$file" ]; then
    lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    if [ "$lines" -gt 500 ]; then
      echo "LARGE FILE ($lines lines): $file"
    fi
  fi
done

# Find large React components (300+ lines)
git diff --name-only HEAD | grep -E "\.tsx$" | while read file; do
  if [ -f "$file" ]; then
    lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    if [ "$lines" -gt 300 ]; then
      echo "LARGE COMPONENT ($lines lines): $file"
    fi
  fi
done
```

**Flag if found**:
- REFACTOR: Files over 500 lines — consider splitting
- REFACTOR: Components over 300 lines — extract sub-components

---

### Phase 4.5: Database Performance [BLOCKING]

Only run if changed files include database queries or API routes.

#### 4.5.1 N+1 Query Patterns

```bash
# Queries inside loops
git diff HEAD -- '**/*.ts' | grep -nE "for\s*\(|while\s*\(|\.forEach\(|\.map\(" -A 10 | grep -E "await.*query"

# Async array methods with database calls
git diff HEAD -- '**/*.ts' | grep -nE "\.map\(async|\.forEach\(async" -A 5 | grep -E "query"
```

**Flag if found**:
- BLOCKING: Queries inside loops (use batch query with IN/ANY clause instead)

#### 4.5.2 Unbounded Queries

```bash
# SELECT without LIMIT or ID filter
git diff HEAD -- '**/*.ts' | grep -nE "SELECT.*FROM" | grep -v "LIMIT|WHERE.*id\s*=|RETURNING|COUNT\(|EXISTS\(|MAX\(|MIN\("
```

**Flag if found**:
- BLOCKING: Unbounded queries without LIMIT (add pagination or ID filter)

#### 4.5.3 Missing Index Patterns [WARNING]

```bash
# Leading wildcard LIKE (full table scan)
git diff HEAD -- '*.ts' '*.tsx' | grep -nE "LIKE\s*['\"]%|LIKE\s*\\\$"

# Functions on indexed columns (prevents index use)
git diff HEAD -- '*.ts' '*.tsx' | grep -nE "WHERE\s*(LOWER|UPPER|TRIM|DATE)\("
```

**Flag if found**:
- WARNING: `LIKE '%term%'` — cannot use B-tree index
- WARNING: Functions on columns in WHERE clause

#### 4.5.4 Missing Transaction Boundaries [WARNING]

```bash
# Multiple writes without transaction
git diff HEAD -- '*.ts' '*.tsx' | grep -E "INSERT|UPDATE|DELETE" | grep -v "BEGIN|COMMIT|ROLLBACK|transaction|\$transaction"
```

**Flag if found**:
- WARNING: Multiple INSERT/UPDATE/DELETE in the same function without a transaction

#### 4.5.5 Data Fetching Issues [BLOCKING]

```bash
# Data fetching hooks inside loops (client-side N+1)
git diff HEAD -- '*.tsx' | grep -nE "\.map\(.*useSWR|\.map\(.*useQuery|\.map\(.*fetch"
```

**Flag if found**:
- BLOCKING: Data fetching hooks (`useSWR`, `useQuery`) inside `.map()` or loops

#### 4.5.6 Sequential Awaits [OPTIMIZATION]

```bash
# Back-to-back independent awaits
git diff HEAD -- '*.ts' '*.tsx' | grep -nE "const.*=\s*await" -A 1 | grep -E "const.*=\s*await"
```

**Flag if found**:
- OPTIMIZATION: Sequential awaits on independent queries — consider `Promise.all([])`

---

### Phase 5: Code Standards Review

#### 5.1 File Naming

```bash
# Check component files are PascalCase
git diff --name-only HEAD | grep -E "src/components/.*\.tsx$" | grep -v "^[A-Z]" | grep -v "/[A-Z]"
```

**Flag if found**:
- WARNING: Component files not in PascalCase

#### 5.2 Styling Consistency

Check that the project's styling approach is followed consistently. If the project uses CSS Modules, check for inline styles. If it uses a utility framework, check for raw CSS where utilities should be used.

```bash
# Check for inline styles when CSS Modules are used
git diff HEAD -- '**/*.tsx' | grep -E "style=\{\{"
```

**Flag if found**:
- WARNING: Inline styles when the project uses CSS Modules or another styling system

---

### Phase 6: Auto-Fix & Report

**This phase is fully automatic — no user prompts.**

#### Step 1: Auto-fix what's possible

Apply fixes silently for:
- Remove `console.log`, `console.warn`, `console.info`, `console.debug` statements (keep `console.error` in catch blocks)
- Remove obviously unused imports that were added in the diff

#### Step 2: Report remaining issues

Present a clean summary of all findings:

```markdown
## Verification Results

### Blocking Issues — N found
- [type] Description — file:line
- [type] Description — file:line

### Warnings — N found
- [type] Description — file:line

### Optimization Suggestions — N found
- [type] Description — file:line

---

**Auto-fixed:** N issues resolved automatically
**Remaining:** N blocking issues need manual attention before committing
```

If there are BLOCKING issues that couldn't be auto-fixed, list them clearly with what needs to change. Do NOT prompt for input — just report.

If all blocking issues are resolved (either auto-fixed or none found), report success and indicate readiness to proceed.

---

## Quick Reference

| Category | Check | Severity |
|----------|-------|----------|
| **Security** |
| Secrets | Hardcoded credentials | BLOCKING |
| SQL Injection | String interpolation in queries | BLOCKING |
| XSS | dangerouslySetInnerHTML | BLOCKING |
| Validation | request.json() without validation | BLOCKING |
| **Best Practices** |
| Debug Code | console.log statements | BLOCKING (auto-fix) |
| TypeScript | `: any` types, `@ts-ignore` | BLOCKING |
| Error Handling | Empty catch blocks | BLOCKING |
| **Efficiency** |
| React Hooks | useEffect without deps | WARNING |
| Imports | Unused imports | WARNING (auto-fix) |
| File Size | 500+ line files, 300+ line components | REFACTOR |
| **Database** |
| N+1 Queries | Queries inside loops | BLOCKING |
| Unbounded SELECT | No LIMIT or ID filter | BLOCKING |
| **Standards** |
| File Naming | Non-PascalCase components | WARNING |
| Styling | Inline styles vs project convention | WARNING |

---

## Notes

- Runs automatically as Phase 0 of `/ship` (mandatory)
- **No interactive prompts** — auto-fixes silently, reports the rest
- Security and best practice issues are BLOCKING — must be resolved before commit
- Efficiency and refactor suggestions are informational only
- All checks are project-agnostic — works with any TypeScript/JavaScript codebase
- Respects project conventions from CLAUDE.md if present