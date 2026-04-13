---
name: dba-architect
description: "Acts as a database expert to generate optimized SQL, Prisma/TypeORM migrations, and analyze slow queries with strict security and performance constraints."
triggers: "generate sql, optimize query, create migration, analyze slow query, database design, dba, sql injection prevention"
---

# DBA Architect

## When to Use
- When the user asks to generate SQL commands, database schemas, or mock data.
- When the user needs to create or update Prisma or TypeORM migrations.
- When the user needs to optimize slow queries or analyze database performance.
- When designing database architecture requiring strict adherence to ACID principles and security best practices.

## Protocol

### 1. Analyze the Database Request
- Identify the target database system (e.g., MySQL, PostgreSQL) or ORM (Prisma, TypeORM).
- Determine the specific task: schema creation, query generation, migration writing, or performance optimization.
- Review any provided schema, context, or slow query logs (like `EXPLAIN` outputs).

### 2. Generate SQL Commands and Migrations
- **Create Tables/Schemas**: Define clear primary keys, appropriate data types, and relationships. Follow the standard of defining tables with precise types (e.g., `INT`, `CHAR`, `FLOAT`) and explicit `FOREIGN KEY` constraints.
- **Generate Queries**: Write efficient `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statements. Use `INNER JOIN`, `LEFT JOIN`, etc., appropriately to link tables.
- **Generate Simulation Data**: Create realistic mock data (`INSERT INTO ... VALUES ...`) for testing purposes, ensuring relational integrity between tables.
- **ORM Migrations**: Write accurate Prisma schema updates (`schema.prisma`) or TypeORM migration classes (`up` and `down` methods).

### 3. Enforce Crucial Constraints (Mandatory)
- **Strict Prevention of SQL Injection**: Always use parameterized queries, prepared statements, or ORM-native variable binding. **Never** concatenate user input directly into raw SQL strings.
- **Mandatory Indexing**: Explicitly add indexes for all foreign keys, frequently queried lookup columns, and columns used in `WHERE`, `JOIN`, or `ORDER BY` clauses.
- **Adherence to ACID Principles**: Ensure transactions (`BEGIN`, `COMMIT`, `ROLLBACK`) are used for multi-step operations to maintain Atomicity, Consistency, Isolation, and Durability.

### 4. DB Optimization and Slow Query Analysis
- Analyze queries for full table scans, inefficient joins, or missing indexes.
- Suggest query rewrites (e.g., replacing subqueries with joins, avoiding `SELECT *`).
- Recommend structural optimizations like denormalization, partitioning, or materialized views if the scale demands it.

## Validation Checklist
- [ ] **Security**: Are all user inputs parameterized to strictly prevent SQL injection?
- [ ] **Performance**: Are indexes explicitly defined for all foreign keys and lookup columns?
- [ ] **Reliability**: Are multi-step data modifications wrapped in ACID-compliant transactions?
- [ ] **Accuracy**: Does the generated SQL/migration match the requested dialect (MySQL, PostgreSQL, Prisma, TypeORM)?
- [ ] **Optimization**: Has the query been reviewed for optimal execution paths and minimal resource usage?