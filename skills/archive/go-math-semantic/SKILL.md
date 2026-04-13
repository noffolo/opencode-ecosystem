---
name: go-math-semantic
description: "Go AI & semantic reasoning: ONNX Runtime binding, vector similarity (cosine/euclidean) with SIMD, knowledge graph structures, parallel matrix math with worker pools, native ontology parsing."
triggers: inferenza go, vettorizzazione dati, logica ontologica, calcolo parallelo matrici, tensor inference, vector math, semantic mapping, ontology query, parallel math, machine learning go, embedding similarity
---

# Go AI & Semantic Reasoning

## When to Use
- "Inferenza go", "vettorizzazione dati", "logica ontologica", "calcolo parallelo matrici"
- Local ML inference, vector similarity, knowledge graph construction
- Semantic reasoning without heavy external dependencies

## Protocol

### 1. Tensor Inference (ONNX Runtime)
Configure ONNX Runtime binding for local inference using GPU/Neural Engine cores:
```go
import "github.com/yalue/onnxruntime_go"

func init() {
    // Set shared library path for ONNX Runtime
    onnxruntime_go.SetSharedLibraryPath("/opt/homebrew/lib/libonnxruntime.dylib")
}

func runInference(modelPath string, input []float32) ([]float32, error) {
    session, err := onnxruntime_go.NewAdvancedSession[float32, float32](
        modelPath,
        []string{"input"},
        []string{"output"},
        []int64{1, int64(len(input))},
        []int64{1, 768}, // output dimension
        nil, // options
    )
    if err != nil {
        return nil, err
    }
    defer session.Destroy()
    
    output := make([]float32, 768)
    err = session.Run(input, output)
    return output, err
}
```
- Use `CPUExecutionProvider` for portability
- For Apple Silicon: enable `CoreMLExecutionProvider` if available

### 2. Vector Math (Similarity Algorithms)
Implement optimized similarity algorithms with loop unrolling and SIMD techniques:
```go
// Cosine similarity with manual unrolling for performance
func CosineSimilarity(a, b []float32) float32 {
    if len(a) != len(b) {
        panic("dimension mismatch")
    }
    var dot, normA, normB float32
    // Process 4 elements at a time (unrolling)
    n := len(a)
    for i := 0; i+3 < n; i += 4 {
        dot += a[i]*b[i] + a[i+1]*b[i+1] + a[i+2]*b[i+2] + a[i+3]*b[i+3]
        normA += a[i]*a[i] + a[i+1]*a[i+1] + a[i+2]*a[i+2] + a[i+3]*a[i+3]
        normB += b[i]*b[i] + b[i+1]*b[i+1] + b[i+2]*b[i+2] + b[i+3]*b[i+3]
    }
    // Handle remainder
    for i := n - (n % 4); i < n; i++ {
        dot += a[i] * b[i]
        normA += a[i] * a[i]
        normB += b[i] * b[i]
    }
    if normA == 0 || normB == 0 {
        return 0
    }
    return dot / (sqrt(normA) * sqrt(normB))
}
```
- **Euclidean distance**: `sqrt(sum((a[i] - b[i])^2))`
- **Dot product**: For normalized vectors, equivalent to cosine similarity
- Consider `gonum.org/v1/gonum/mat` for large matrix operations

### 3. Semantic Mapping (Knowledge Graphs)
Manage knowledge graphs using `map[string]Entity` with semantic validation:
```go
type Entity struct {
    ID          string
    Type        string
    Properties  map[string]any
    Relations   []Relation
}

type Relation struct {
    TargetID string
    Type     string
    Weight   float64
}

type KnowledgeGraph struct {
    nodes map[string]*Entity
    edges map[string][]Relation // sourceID -> relations
}

func (kg *KnowledgeGraph) AddRelation(source, target, relType string, weight float64) {
    if kg.edges[source] == nil {
        kg.edges[source] = []Relation{}
    }
    kg.edges[source] = append(kg.edges[source], Relation{
        TargetID: target,
        Type:     relType,
        Weight:   weight,
    })
}
```

### 4. Parallel Math (Worker Pools)
Use Divide et Impera with worker pools for large matrix computations, minimizing channel overhead:
```go
func ParallelMatrixMultiply(a, b [][]float64, workers int) [][]float64 {
    n := len(a)
    result := make([][]float64, n)
    for i := range result {
        result[i] = make([]float64, n)
    }
    
    jobs := make(chan int, n)
    var wg sync.WaitGroup
    
    for w := 0; w < workers; w++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for i := range jobs {
                for j := 0; j < n; j++ {
                    var sum float64
                    for k := 0; k < n; k++ {
                        sum += a[i][k] * b[k][j]
                    }
                    result[i][j] = sum
                }
            }
        }()
    }
    
    for i := 0; i < n; i++ {
        jobs <- i
    }
    close(jobs)
    wg.Wait()
    return result
}
```
- Workers = `runtime.NumCPU()` (8 for M2 Pro)
- Minimize channel sends: batch work items when possible

### 5. Ontology Query (Native Parser)
Implement a native Go parser for querying ontological relationships without heavy external dependencies:
```go
type OntologyQuery struct {
    Subject    string
    Predicate  string
    Object     string
}

func (kg *KnowledgeGraph) Query(q OntologyQuery) []Entity {
    var results []Entity
    for id, entity := range kg.nodes {
        if q.Subject != "" && id != q.Subject {
            continue
        }
        if q.Predicate != "" {
            found := false
            for _, rel := range kg.edges[id] {
                if rel.Type == q.Predicate {
                    found = true
                    break
                }
            }
            if !found {
                continue
            }
        }
        results = append(results, *entity)
    }
    return results
}
```

## Validation Checklist

- [ ] ONNX model loading does not exceed 4GB RAM (safety limit for 16GB systems)
- [ ] Vector similarity results match reference implementation within 0.001 tolerance
- [ ] Worker pool scales linearly up to `runtime.NumCPU()` workers
- [ ] Knowledge graph queries return correct results for edge cases (empty graph, self-loops)
- [ ] Cross-check with CodeMEM for alignment to core ontology schemas
