---
name: go-security-ebpf
description: "Go system security: eBPF orchestration via cilium/ebpf, modern crypto (TLS 1.3, Ed25519), go/ast static analysis, RBAC/ABAC middleware with OPA, secure secret storage."
triggers: sicurezza crittografica, monitoring ebpf, hardened middleware, audit di sistema, go security, ebpf kernel, tls configuration, static analysis go, gosec, RBAC, ABAC, OPA, secret management, keychain
---

# Go System Security & eBPF

## When to Use
- "Sicurezza crittografica", "monitoring ebpf", "hardened middleware", "audit di sistema"
- Kernel-level security monitoring, cryptographic hardening, policy enforcement
- Static security analysis and secret management

## Protocol

### 1. eBPF Orchestration
Use `cilium/ebpf` to load programs into the kernel for security metrics or syscall interception:
```go
import (
    "github.com/cilium/ebpf"
    "github.com/cilium/ebpf/link"
    "github.com/cilium/ebpf/ringbuf"
)

func loadSecurityMonitor() (*ebpf.Collection, error) {
    spec, err := ebpf.LoadCollectionSpec("security_monitor.o")
    if err != nil {
        return nil, fmt.Errorf("load collection spec: %w", err)
    }
    
    coll, err := ebpf.NewCollection(spec)
    if err != nil {
        return nil, fmt.Errorf("new collection: %w", err)
    }
    return coll, nil
}

func traceExecEvents(execProg *ebpf.Program) (link.Link, error) {
    l, err := link.Tracepoint("syscalls", "sys_enter_execve", execProg, nil)
    if err != nil {
        return nil, fmt.Errorf("tracepoint: %w", err)
    }
    return l, nil
}
```
- Requires `CAP_BPF` and `CAP_PERFMON` capabilities
- Use `ringbuf` for high-performance event reading (lower overhead than perf buffer)
- Always verify eBPF program passes verifier before loading

### 2. Advanced Crypto
Use exclusively `crypto/tls` with modern configurations (TLS 1.3, Ed25519) and automatic secret rotation:
```go
import (
    "crypto/tls"
    "crypto/ed25519"
    "crypto/x509"
)

func secureTLSConfig(cert tls.Certificate) *tls.Config {
    return &tls.Config{
        MinVersion:   tls.VersionTLS13,
        CipherSuites: []uint16{
            tls.TLS_AES_128_GCM_SHA256,
            tls.TLS_AES_256_GCM_SHA384,
            tls.TLS_CHACHA20_POLY1305_SHA256,
        },
        Certificates: []tls.Certificate{cert},
        CurvePreferences: []tls.CurveID{
            tls.CurveP256,
            tls.X25519,
        },
    }
}

func generateEd25519Key() (ed25519.PrivateKey, error) {
    _, priv, err := ed25519.GenerateKey(nil)
    return priv, err
}
```
- **Never** use TLS 1.2 or below
- **Never** use RSA key exchange
- Rotate certificates automatically via ACME or internal CA
- Use Ed25519 for signing (faster than ECDSA, smaller than RSA)

### 3. Static Analysis (go/ast)
Analyze code via `go/ast` to identify weak security patterns before compilation:
```go
import (
    "go/ast"
    "go/parser"
    "go/token"
)

func scanForWeakCrypto(filePath string) ([]string, error) {
    fset := token.NewFileSet()
    node, err := parser.ParseFile(fset, filePath, nil, 0)
    if err != nil {
        return nil, err
    }
    
    var issues []string
    ast.Inspect(node, func(n ast.Node) bool {
        call, ok := n.(*ast.CallExpr)
        if !ok {
            return true
        }
        // Detect MD5 usage
        if sel, ok := call.Fun.(*ast.SelectorExpr); ok {
            if ident, ok := sel.X.(*ast.Ident); ok {
                if ident.Name == "md5" {
                    issues = append(issues, 
                        fmt.Sprintf("MD5 usage detected at %s", fset.Position(call.Pos())))
                }
            }
        }
        return true
    })
    return issues, nil
}
```
- Run `go vet` on every commit
- Run `gosec` for comprehensive security linting: `gosec ./...`
- Add custom AST rules for project-specific security policies

### 4. Hardened Middleware (RBAC/ABAC with OPA)
Build authorization layers with granular logic integrated with Open Policy Agent:
```go
import "github.com/open-policy-agent/opa/rego"

type AuthzRequest struct {
    Subject  string
    Action   string
    Resource string
    Context  map[string]any
}

func evaluatePolicy(req AuthzRequest, policyPath string) (bool, error) {
    query := fmt.Sprintf("data.%s.allow", filepath.Base(policyPath))
    
    r := rego.New(
        rego.Query(query),
        rego.Load([]string{policyPath}, nil),
    )
    
    ctx := context.Background()
    preparedQuery, err := r.PrepareForEval(ctx)
    if err != nil {
        return false, fmt.Errorf("prepare query: %w", err)
    }
    
    results, err := preparedQuery.Eval(ctx, rego.EvalInput(req))
    if err != nil {
        return false, fmt.Errorf("eval: %w", err)
    }
    
    if len(results) == 0 {
        return false, nil
    }
    
    bindings := results[0].Bindings
    allowed, ok := bindings["allow"].(bool)
    return ok && allowed, nil
}
```
- RBAC: Role-based — simple, good for small teams
- ABAC: Attribute-based — flexible, good for complex policies
- OPA: Centralized policy engine — reusable across services

### 5. Secure Storage
Integrate with system Keychain or Vault for secret management at rest:
```go
// macOS Keychain integration via security CLI
func storeInKeychain(service, account, secret string) error {
    cmd := exec.Command("security", "add-generic-password",
        "-s", service,
        "-a", account,
        "-w", secret,
        "-U", // update if exists
    )
    return cmd.Run()
}

func readFromKeychain(service, account string) (string, error) {
    cmd := exec.Command("security", "find-generic-password",
        "-s", service,
        "-a", account,
        "-w",
    )
    out, err := cmd.Output()
    if err != nil {
        return "", fmt.Errorf("keychain read: %w", err)
    }
    return strings.TrimSpace(string(out)), nil
}
```
- For production: Use HashiCorp Vault or AWS Secrets Manager
- For local dev: macOS Keychain or `pass` (password-store)
- Never store secrets in plaintext files or environment variables long-term

## Validation Checklist

- [ ] `go vet` passes with zero warnings
- [ ] `gosec ./...` reports no HIGH or CRITICAL issues
- [ ] eBPF programs load successfully with required privileges
- [ ] TLS configuration rejects TLS 1.2 and below connections
- [ ] All secrets are stored in Keychain/Vault, not in code or .env files
- [ ] OPA policies return expected allow/deny decisions for test cases
