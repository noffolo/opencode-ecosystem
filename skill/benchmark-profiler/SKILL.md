---
name: benchmark-profiler
description: "Compare code performance between versions using hyperfine, pprof, or Python timeit. Generates benchmark reports with before/after metrics."
triggers: benchmark, performance comparison, hyperfine, profiling, speed test, confronta performance, misura velocita, tempo esecuzione
---

# Benchmark Profiler

## When to Use
- "Benchmark", "performance comparison", "hyperfine", "profiling"
- When you need to prove a change is actually faster, not just "should be"
- Comparing AI-suggested code against current implementation

## Protocol

### 1. Install hyperfine (if needed)
```bash
brew install hyperfine
```

### 2. Define the Comparison
Identify what to measure:
- **Command A**: Current implementation
- **Command B**: New/suggested implementation
- **Warmup runs**: 3 (to prime caches)
- **Benchmark runs**: 10+ (for statistical significance)

### 3. Run the Benchmark
```bash
hyperfine --warmup 3 --runs 10 \
  --name "current"   "command-a" \
  --name "proposed"  "command-b" \
  --export-markdown benchmark-report.md \
  --export-json benchmark-data.json
```

### 4. Language-Specific Profiling

**Go (pprof):**
```bash
go test -bench=. -benchmem -cpuprofile=cpu.prof -memprofile=mem.prof
go tool pprof -top cpu.prof
go tool pprof -top mem.prof
```

**Python (timeit + cProfile):**
```python
import timeit
import cProfile

# Simple timing
timeit.timeit("function()", setup="from module import function", number=10000)

# Detailed profiling
cProfile.run("function()", "profile.stats")
# Then: python3 -m pstats profile.stats
```

**Node.js (clinic.js):**
```bash
npx clinic doctor -- node app.js
npx clinic flame -- node app.js
```

### 5. Generate Report
Create a comparison table:

| Metric | Current | Proposed | Change |
|--------|---------|----------|--------|
| Mean time | X ms | Y ms | +/- Z% |
| Memory | X MB | Y MB | +/- Z% |
| Allocations | X | Y | +/- Z% |

### 6. Verdict
- If proposed is >= 10% faster: recommend the change
- If difference is < 5%: not worth the risk, keep current
- If proposed is slower: explain why and suggest alternatives

## Validation Checklist

- [ ] Warmup runs completed before measurement
- [ ] At least 10 benchmark runs for statistical significance
- [ ] Same input data for both versions
- [ ] Environment is stable (no other heavy processes running)
- [ ] Results exported to markdown and JSON for reference
- [ ] Verdict includes percentage change, not just "faster/slower"
