---
name: go-hardened-core
description: "High-performance Go optimization: pprof memory profiling, zero-copy I/O, lock-free atomics, GC tuning for M2 Pro 16GB, and goleak leak detection."
triggers: ottimizza performance go, analisi memoria golang, zero-copy implementation, concurrency avanzata, gc tuning, memory profiling, atomic operations, lock-free, go performance, heap allocation
---

# Go Hardened Core & Performance

## When to Use
- "Ottimizza performance go", "analisi memoria golang", "zero-copy implementation"
- Memory profiling, GC tuning, lock-free concurrency
- High-throughput systems requiring minimal allocations

## Protocol

### 1. Memory Profiling
Use `pprof` and `runtime/trace` to identify bottlenecks and excessive heap allocations:
```bash
go test -bench=. -memprofile=mem.prof -cpuprofile=cpu.prof
go tool pprof -http=:8080 mem.prof
```
Focus on:
- `alloc_space` vs `inuse_space` — find allocation hotspots
- `runtime.mallocgc` calls — identify unnecessary allocations
- Escape analysis: `go build -gcflags="-m"` — find heap escapes

### 2. Zero-Copy Architecture
Implement `io.ReaderFrom` and `io.WriterTo` to minimize user-space ↔ kernel-space copies:
```go
func (f *File) WriteTo(w io.Writer) (n int64, err error) {
    // Use syscall.Sendfile or io.Copy with splice for zero-copy
    return io.Copy(w, f.reader)
}
```
- Prefer `bytes.Buffer` over string concatenation
- Use `sync.Pool` for frequently allocated/deallocated buffers
- Avoid `[]byte` copies in hot paths — pass slices by reference

### 3. Atomic & Lock-Free
Prefer `sync/atomic` over mutexes for high-frequency counters and state machines:
```go
var counter atomic.Int64
counter.Add(1) // lock-free increment
```
- Use `atomic.Pointer[T]` for lock-free struct swaps
- Avoid mutex contention in read-heavy paths — use `sync.RWMutex` or atomics
- For complex state, use channel-based state machines (single writer)

### 4. GC Tuning (M2 Pro 16GB)
Configure `GOGC` and `GOMEMLIMIT` to prevent aggressive garbage collection cycles:
```go
import "runtime/debug"

func init() {
    // Set memory limit to 4GB (safety margin for 16GB system)
    debug.SetMemoryLimit(4 * 1024 * 1024 * 1024)
    // Tune GC: default is 100, increase to reduce GC frequency
    // debug.SetGCPercent(200)
}
```
- `GOGC=100` (default): GC runs when heap doubles
- `GOGC=200`: GC runs when heap triples (less frequent, more memory)
- `GOMEMLIMIT`: Hard cap — GC throttles to stay under limit
- For 16GB M2 Pro: Set `GOMEMLIMIT` to 4-6GB per process

### 5. CodeMEM Integration
Query CodeMEM for previously applied optimization patterns on ARM64 architectures before implementing new ones.

## Validation Checklist

- [ ] No memory leaks verified via `uber-go/goleak`
- [ ] Benchmark `ns/op` meets project targets (check CodeMEM)
- [ ] `go test -race` passes with zero data races
- [ ] Escape analysis shows minimal heap allocations in hot paths
- [ ] GC pause times < 1ms under load (verify with `GODEBUG=gctrace=1`)
