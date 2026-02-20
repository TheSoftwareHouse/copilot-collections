---
sidebar_position: 8
title: SQL & Database
---

# SQL & Database

**Folder:** `.github/skills/sql-and-database/`  
**Used by:** Architect, Code Reviewer, Software Engineer

The most comprehensive skill (~1200 lines), providing end-to-end database engineering standards. Applies to PostgreSQL, MySQL, MariaDB, SQL Server, and Oracle. Covers ORM usage with TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.

## Topics Covered

### 1. Schema Architecture Design

- Naming conventions (snake_case, singular nouns).
- Standard columns (`id`, `created_at`, `updated_at`, `deleted_at`).
- Primary key strategy (UUID vs auto-increment).
- Data type selection.
- Enum handling patterns.

### 2. Normalisation Strategies

- 1NF through BCNF with practical examples.
- When and how to strategically denormalise.

### 3. Relationships & Foreign Keys

- One-to-Many, Many-to-Many, One-to-One patterns.
- `ON DELETE` / `ON UPDATE` cascade strategies.
- Self-referencing tables and hierarchy patterns.

### 4. Indexing

| Index Type | Use For |
|---|---|
| **B-tree** | Equality and range queries (default) |
| **Hash** | Equality-only lookups |
| **GIN** | Full-text search, JSONB, arrays |
| **GiST** | Spatial and geometric data |
| **BRIN** | Large tables with natural ordering |
| **Partial** | Queries on a subset of rows |
| **Composite** | Multi-column queries (column order matters) |

### 5. Writing Performant SQL

- Query rules and JOIN optimization.
- Keyset pagination vs OFFSET.
- CTEs and window functions.

### 6. Transactions & Locking

- Isolation levels (Read Committed, Repeatable Read, Serializable).
- Row-level and advisory locks.
- Deadlock prevention strategies.

### 7. Query Debugging

- `EXPLAIN ANALYZE` for reading execution plans.
- Common performance fixes.

### 8. ORM Integration

Guidelines for 7 major ORMs: TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, GORM.

### 9. Maintenance & Monitoring

- VACUUM, statistics refresh.
- Connection pooling.
- Backup strategies.

## Guiding Principles

1. **Data Integrity First** — Constraints at the database level.
2. **Least Privilege** — Minimal permissions per role.
3. **Explicit Over Implicit** — No magic defaults.
4. **Measure Before Optimising** — Profile before adding indexes.
5. **Schema as Code** — All changes via versioned migrations.
