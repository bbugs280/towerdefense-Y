# Agent Prompt: Documentation Updates

## Rule: Always Update Version Numbers

When updating any documentation file, **always** follow this checklist:

### Before Editing
1. **Check current version** — Read the file header for version number
2. **Determine if content change warrants version bump**:
   - Minor typo fix → same version, no rename
   - Content update (status, decisions, risks) → bump minor version (v1.0 → v1.1)
   - Major restructuring → bump major version (v1.1 → v2.0)

### When Bumping Version
1. **Rename the file** to match new version:
   ```bash
   mv architecture-v1.md architecture-v1.1.md
   ```
2. **Update the file header** with:
   - New version number in title
   - File name reference
   - Previous file name (deprecated)
   - Next review date
3. **Update any references** to the old filename in other docs
4. **Commit with clear message**:
   ```bash
   git commit -m "Update architecture doc to v1.1: [brief summary]"
   ```

### Header Template

```markdown
# 🐾 PawMind — [Document Title] (vX.Y)

**File:** `filename-vX.Y.md`  
**Version:** X.Y  
**Previous:** `filename-vX.(Y-1).md` (deprecated, renamed YYYY-MM-DD)  
**Next Review:** [date or milestone]

---
```

### Common Mistakes to Avoid

❌ **Wrong:** Update content but keep old filename  
❌ **Wrong:** Rename file but don't update header metadata  
❌ **Wrong:** Create new file without deprecating old one  
✅ **Right:** Rename + update header + commit atomically

### Enforcement

Before committing any doc change, ask:
- "Did I bump the version number in the filename?"
- "Did I update the header metadata?"
- "Are there any stale references to the old filename?"

---

*Created: 2026-03-28 after architecture-v1.md was updated without renaming to v1.1*
