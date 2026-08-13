# Graph Report - .  (2026-08-13)

## Corpus Check
- Corpus is ~514 words - fits in a single context window. You may not need a graph.

## Summary
- 25 nodes · 49 edges · 4 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: PARENT_OF: 25 · ON_BRANCH: 24


## Input Scope
- Requested: auto
- Resolved: committed (source: default-auto)
- Included files: 1 · Candidates: 9
- Excluded: 0 untracked · 0 ignored · 0 sensitive · 0 missing committed
- Recommendation: Use --scope all or graphify.yaml inputs.corpus for a knowledge-base folder.

## Graph Freshness
- Built from Git commit: `bf58b15`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)

## Surprising Connections (you probably didn't know these)
- `013d2d1 👌` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 3 → community 0_
- `069f773 Merge branch 'main' of https://github.com/skeletorflet/AHKv2-Toastification` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 1 → community 0_
- `3d48eab Try DPI Scale Fixing` --PARENT_OF--> `296a4c9 DPI process`  [EXTRACTED]
  git → git  _Bridges community 3 → community 1_
- `53ae881 Start repo` --ON_BRANCH--> `main`  [EXTRACTED]
  git → git  _Bridges community 2 → community 0_
- `53ae881 Start repo` --PARENT_OF--> `e750ea4 Garbage`  [EXTRACTED]
  git → git  _Bridges community 2 → community 3_

## Communities

### Community 0 - "Community 0"
Cohesion: 0.42
Nodes (9): main, 2c441b9 g, 3ded615 start, 7897176 little fix, 8a046ba ojk, bfc5abe Fixed, c667131 ok, fb49507 Try fix (+1 more)

### Community 1 - "Community 1"
Cohesion: 0.33
Nodes (7): 069f773 Merge branch 'main' of https://github.com/skeletorflet/AHKv2-Toastification, 296a4c9 DPI process, 59b51f4 Create test_animations.ahk, bd81228 Merge branch 'main' of https://github.com/skeletorflet/AHKv2-Toastification, bf58b15 perf(toast): optimize render pipeline, timer consolidation & theme palettes, e39c0d4 Some fixes, fe0a045 very good for now

### Community 2 - "Community 2"
Cohesion: 0.40
Nodes (5): 53ae881 Start repo, 8931351 for now ok., a1b3a79 g, b940e2c good, f350ad3 fornow

### Community 3 - "Community 3"
Cohesion: 0.50
Nodes (4): 013d2d1 👌, 274f2ca Update .gitignore, 3d48eab Try DPI Scale Fixing, e750ea4 Garbage

## Suggested Questions
_Not enough signal to generate questions. This usually means the corpus has no AMBIGUOUS edges, no bridge nodes, no INFERRED relationships, and all communities are tightly cohesive. Add more files or run with --mode deep to extract richer edges._