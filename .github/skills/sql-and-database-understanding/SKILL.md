---
name: sql-and-database-understanding
description: SQL writing and database engineering patterns, standards, and procedures. Use for designing database schemas, writing performant SQL queries, normalisation strategies, indexing, joins optimisation, locking mechanics, transactions, query debugging with EXPLAIN, and ORM integration. Applies to PostgreSQL, MySQL, MariaDB, SQL Server, and Oracle. Covers ORM usage with TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.
---

# SQL & Database Engineering

This skill provides standards, patterns, and procedures for database schema design, writing performant SQL, query debugging, and database engineering best practices. It is database-engine-agnostic with notes on engine-specific behavior where critical.

## Guiding Principles

| Principle | Application |
|---|---|
| **Data Integrity First** | Enforce constraints at the database level (NOT NULL, UNIQUE, FK, CHECK). Never rely solely on application-level validation. |
| **Least Privilege** | Database users/roles should have only the permissions they need. Application connections should never use the superuser account. |
| **Explicit Over Implicit** | Always specify column lists in SELECT, INSERT, and JOIN clauses. Avoid `SELECT *` in production code. |
| **Measure Before Optimising** | Use `EXPLAIN ANALYZE` to identify actual bottlenecks before adding indexes or restructuring queries. |
| **Schema as Code** | All schema changes go through versioned migration files. Never modify production schemas manually. |

---

## 1. Database Schema Architecture Design

### Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Tables | `snake_case`, plural nouns | `order_items`, `user_addresses` |
| Columns | `snake_case` | `first_name`, `created_at` |
| Primary keys | `id` (preferred) or `<table_singular>_id` | `id`, `user_id` |
| Foreign keys | `<referenced_table_singular>_id` | `user_id`, `order_id` |
| Indexes | `idx_<table>_<columns>` | `idx_orders_user_id_status` |
| Unique constraints | `uq_<table>_<columns>` | `uq_users_email` |
| Check constraints | `chk_<table>_<description>` | `chk_orders_total_positive` |
| Junction/pivot tables | `<table1>_<table2>` (alphabetical) | `products_tags`, `roles_users` |

### Standard Columns

Every table **MUST** include:

```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- or BIGSERIAL for auto-increment
    -- ... domain columns ...
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
```

When soft deletes are required by business rules:

```sql
deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
```

### Primary Key Strategy

| Strategy | When to Use | Trade-offs |
|---|---|---|
| `UUID v4` / `UUID v7` | Distributed systems, microservices, public-facing IDs | Larger storage, random UUIDs cause index fragmentation (prefer UUID v7 for ordered inserts) |
| `ULID` | When you need sortable unique IDs with good index locality | Not natively supported in all databases |
| `BIGSERIAL` / `IDENTITY` | Single-database monoliths, internal IDs | Sequential, predictable (security concern if exposed), not portable across DB instances |

**Rule:** Never expose auto-increment IDs in public APIs. Use UUIDs or ULIDs for external identifiers.

### Data Types — Choose Precisely

| Need | Use | Avoid |
|---|---|---|
| Monetary values | `NUMERIC(19,4)` or `DECIMAL(19,4)` | `FLOAT`, `DOUBLE` (precision loss) |
| Timestamps | `TIMESTAMP WITH TIME ZONE` | `TIMESTAMP` without timezone |
| Boolean flags | `BOOLEAN` | `TINYINT`, `CHAR(1)` |
| Short text (name, email) | `VARCHAR(n)` with appropriate limit | Unbounded `TEXT` for structured fields |
| Long text (descriptions) | `TEXT` | `VARCHAR(10000)` |
| Enums | `VARCHAR` with CHECK constraint or native ENUM | Magic integers |
| JSON/semi-structured | `JSONB` (PostgreSQL) or `JSON` | Storing relational data as JSON |
| IP addresses | `INET` (PostgreSQL) or `VARCHAR(45)` | `VARCHAR(15)` (IPv6 won't fit) |

### Enum Handling

Prefer CHECK constraints over native ENUM types for portability and ease of migration:

```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CONSTRAINT chk_orders_status CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
```

Adding a new enum value is a simple `ALTER TABLE ... DROP CONSTRAINT` + `ADD CONSTRAINT`, no table rewrite required.

### Schema Design Checklist

```
Schema design checklist:
- [ ] Every table has a primary key (UUID or BIGSERIAL)
- [ ] Every table has created_at and updated_at columns
- [ ] All foreign keys have corresponding indexes
- [ ] All columns have appropriate NOT NULL constraints
- [ ] Unique constraints are defined where business rules require uniqueness
- [ ] CHECK constraints enforce valid value ranges and enums
- [ ] Naming follows snake_case conventions consistently
- [ ] Data types are chosen precisely (no FLOAT for money, no TEXT for emails)
- [ ] Soft delete (deleted_at) is used only where business rules require it
- [ ] No business logic is embedded in database triggers or stored procedures (keep logic in the application layer)
```

---

## 2. Normalisation Strategies

### Normal Forms Reference

| Normal Form | Rule | Violation Example | Fix |
|---|---|---|---|
| **1NF** | Every column holds atomic (indivisible) values. No repeating groups. | `tags: "php,sql,go"` in a single column | Create a separate `tags` table with a junction table |
| **2NF** | 1NF + every non-key column depends on the **entire** primary key (relevant for composite keys) | `order_items(order_id, product_id, product_name)` — `product_name` depends only on `product_id` | Move `product_name` to the `products` table |
| **3NF** | 2NF + no transitive dependencies (non-key column depends on another non-key column) | `employees(id, department_id, department_name)` — `department_name` depends on `department_id`, not on `id` | Move `department_name` to a `departments` table |
| **BCNF** | 3NF + every determinant is a candidate key | Rare in practice; address when composite keys create functional dependency issues | Decompose the table so every determinant is a key |

### When to Use Each Level

**Target 3NF by default.** This eliminates redundancy while keeping the schema manageable.

**Use 2NF** only as an intermediate step when refactoring legacy schemas — never as a design target.

**Use BCNF** when you have composite primary keys with overlapping candidate keys (uncommon in application databases).

### Practical Normalisation Example

**Unnormalised (0NF):**

```
orders:
| order_id | customer_name | customer_email      | items                          |
|----------|---------------|---------------------|--------------------------------|
| 1        | John Doe      | john@example.com    | Widget x2, Gadget x1           |
```

**1NF — Atomic values, no repeating groups:**

```sql
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0)
);
```

**2NF — Remove partial dependencies (product details depend on product, not order):**

```sql
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(19,4) NOT NULL
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(19,4) NOT NULL  -- snapshot of price at order time
);
```

**3NF — Remove transitive dependencies (customer depends on customer, not order):**

```sql
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
```

### Strategic Denormalisation

Denormalise **only** when you have measured performance data (via `EXPLAIN ANALYZE`) proving that joins are the bottleneck. Common valid cases:

| Pattern | When to Use | Example |
|---|---|---|
| **Materialised/cached columns** | Frequently read aggregate that is expensive to compute on every query | `orders.total_amount` computed from `order_items` and stored on the order row |
| **Snapshot columns** | Values that must be preserved at a point in time even if the source changes | `order_items.unit_price` (price at time of purchase, not current product price) |
| **Read-optimised views** | Reporting or analytics queries that span many tables | Materialised views refreshed periodically |
| **Search/filter columns** | Columns derived from related tables used heavily in WHERE clauses | `orders.customer_country` duplicated from `customers.country` for filtering |

**Rules for denormalisation:**
- Always document **why** the denormalisation exists (code comment + migration description).
- Ensure the denormalised data is kept in sync (application-level updates, triggers as last resort, or materialised view refresh).
- Treat denormalised data as a **cache** — the normalised source remains the source of truth.

---

## 3. Relationships & Foreign Keys

### Relationship Types

**One-to-Many (most common):**

```sql
-- A customer has many orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

**Many-to-Many (junction table):**

```sql
-- Products can have many tags, tags can belong to many products
CREATE TABLE products_tags (
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    tag_id BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, tag_id)
);

CREATE INDEX idx_products_tags_tag_id ON products_tags(tag_id);
```

**One-to-One:**

```sql
-- Each user has exactly one profile
CREATE TABLE user_profiles (
    user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    bio TEXT,
    avatar_url VARCHAR(500)
);
```

### ON DELETE / ON UPDATE Actions

| Action | Meaning | When to Use |
|---|---|---|
| `RESTRICT` (default) | Prevent deletion if referenced rows exist | Default for most business entities (prevent accidental data loss) |
| `CASCADE` | Delete/update child rows when parent is deleted/updated | Junction tables, dependent child records that have no meaning without parent |
| `SET NULL` | Set FK to NULL when parent is deleted | Optional relationships where the child can exist independently |
| `SET DEFAULT` | Set FK to its default value | Rare — use when a fallback reference makes business sense |
| `NO ACTION` | Same as RESTRICT but checked at end of transaction | When deferred constraint checking is needed |

**Rule:** Default to `RESTRICT`. Use `CASCADE` only on junction tables and tightly coupled child tables. Always explicitly specify the action — never rely on implicit defaults.

### Self-Referencing Relationships

```sql
-- Categories with parent-child hierarchy
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL
);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);
```

For deep hierarchies (trees), consider:
- **Adjacency list** (above) — simple, good for shallow trees
- **Materialised path** — `path VARCHAR(500)` storing `/1/5/12/` — good for read-heavy trees
- **Nested sets** — complex to maintain but fast for subtree queries
- **Closure table** — separate table storing all ancestor-descendant pairs — balanced read/write performance

---

## 4. Indexes

### Index Types

| Type | Syntax (PostgreSQL) | Use Case |
|---|---|---|
| **B-tree** (default) | `CREATE INDEX idx ON table(column)` | Equality and range queries (`=`, `<`, `>`, `BETWEEN`, `ORDER BY`) |
| **Hash** | `CREATE INDEX idx ON table USING hash(column)` | Equality-only lookups (rare — B-tree covers this equally well) |
| **GIN** | `CREATE INDEX idx ON table USING gin(column)` | Full-text search, JSONB containment, array operations |
| **GiST** | `CREATE INDEX idx ON table USING gist(column)` | Geometric/spatial data, range types, nearest-neighbor queries |
| **BRIN** | `CREATE INDEX idx ON table USING brin(column)` | Very large tables with naturally ordered data (timestamps, sequential IDs) |

### Index Strategy Rules

**Always index:**
- Foreign key columns (not auto-indexed in PostgreSQL/MySQL InnoDB)
- Columns frequently used in `WHERE` clauses
- Columns used in `ORDER BY` on large tables
- Columns used in `JOIN` conditions

**Consider composite indexes for:**
- Queries that filter on multiple columns together
- Covering indexes that satisfy a query entirely from the index

**Avoid over-indexing:**
- Each index adds overhead to `INSERT`, `UPDATE`, and `DELETE` operations
- Indexes consume storage
- Review and remove unused indexes periodically

### Composite Index Column Order

The order of columns in a composite index matters. Place columns in this priority:

1. **Equality conditions first** (`WHERE status = 'active'`)
2. **Range conditions second** (`WHERE created_at > '2025-01-01'`)
3. **Sort columns last** (`ORDER BY created_at DESC`)

```sql
-- Query: WHERE status = 'active' AND created_at > '2025-01-01' ORDER BY created_at DESC
-- Optimal index:
CREATE INDEX idx_orders_status_created_at ON orders(status, created_at DESC);
```

### Partial Indexes

Index only the rows you actually query:

```sql
-- Only index active orders (if most queries filter for active)
CREATE INDEX idx_orders_active ON orders(customer_id, created_at)
    WHERE deleted_at IS NULL;
```

### Unique Indexes

Use unique indexes to enforce business constraints:

```sql
-- Email must be unique, but only for non-deleted users
CREATE UNIQUE INDEX uq_users_email_active ON users(email)
    WHERE deleted_at IS NULL;
```

### Index Monitoring

Periodically check for unused indexes:

```sql
-- PostgreSQL: find unused indexes
SELECT
    schemaname, relname AS table_name, indexrelname AS index_name,
    idx_scan AS times_used, pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Non-Blocking Index Operations (CONCURRENTLY)

Standard `CREATE INDEX` and `DROP INDEX` acquire locks that **block writes** on the table for the duration of the operation. On large or heavily-used tables this can cause downtime.

**Always use `CONCURRENTLY`** when creating or dropping indexes on tables that serve live traffic:

```sql
-- Creating an index without blocking writes
CREATE INDEX CONCURRENTLY idx_orders_customer_id ON orders(customer_id);

-- Dropping an index without blocking writes
DROP INDEX CONCURRENTLY idx_orders_customer_id;
```

**Key constraints and caveats:**

| Aspect | Detail |
|---|---|
| **Database support** | `CONCURRENTLY` is PostgreSQL-specific. Other engines have their own online indexing alternatives: MySQL/MariaDB use `ALGORITHM=INPLACE, LOCK=NONE`; SQL Server uses `WITH (ONLINE = ON)`; Oracle uses `ONLINE` keyword. Consult engine-specific docs for constraints and limitations |
| **Transaction blocks** | `CREATE INDEX CONCURRENTLY` and `DROP INDEX CONCURRENTLY` **cannot run inside a transaction block** — avoid wrapping them in `BEGIN`/`COMMIT` |
| **Migration frameworks** | Most migration tools wrap statements in a transaction by default. Disable this for concurrent index operations (e.g., `disable_ddl_transaction!` in Rails, `atomic = False` in Django, separate migration step in Flyway) |
| **Failed builds** | If `CREATE INDEX CONCURRENTLY` fails, it leaves behind an **invalid index**. Check with `\d table_name` and drop the invalid index before retrying |
| **Unique indexes** | `CREATE UNIQUE INDEX CONCURRENTLY` performs an extra table scan — takes longer but still avoids blocking writes |
| **Build time** | Concurrent builds are slower than regular ones because they require multiple table passes |

**When to skip `CONCURRENTLY`:**
- Initial schema setup or empty tables (no live traffic to block)
- During a maintenance window with no active connections
- Test/development environments

---

## 5. Writing Performant SQL Queries

### Query Writing Rules

| Rule | Do | Don't |
|---|---|---|
| Specify columns | `SELECT id, name, email FROM users` | `SELECT * FROM users` |
| Use parameterised queries | `WHERE id = $1` / `WHERE id = ?` | `WHERE id = '` + userId + `'` (SQL injection risk) |
| Limit results | `LIMIT 100` or paginate | Unbounded `SELECT` on large tables |
| Filter early | `WHERE` clause narrows rows before joins | Joining full tables then filtering |
| Use EXISTS over IN for subqueries | `WHERE EXISTS (SELECT 1 FROM ...)` | `WHERE id IN (SELECT id FROM ...)` on large sets |
| Avoid functions on indexed columns | `WHERE created_at >= '2025-01-01'` | `WHERE DATE(created_at) = '2025-01-01'` (kills index) |
| Use UNION ALL over UNION | `UNION ALL` when duplicates are acceptable | `UNION` (forces sort + dedup) |

### JOIN Optimisation

#### Join Types and When to Use

| Join Type | Returns | Use When |
|---|---|---|
| `INNER JOIN` | Only matching rows from both tables | You need data that exists in both tables |
| `LEFT JOIN` | All rows from left table + matches from right (NULL if no match) | You need all records from the primary table regardless of match |
| `RIGHT JOIN` | All rows from right table + matches from left | Rarely used — rewrite as LEFT JOIN for readability |
| `CROSS JOIN` | Cartesian product of both tables | Generating combinations (e.g., all products × all regions) |
| `LATERAL JOIN` | Correlated subquery for each row | Top-N per group, complex per-row calculations |

#### Join Performance Guidelines

```sql
-- GOOD: Join on indexed columns, filter early
SELECT o.id, o.created_at, c.name
FROM orders o
INNER JOIN customers c ON c.id = o.customer_id
WHERE o.status = 'active'
  AND o.created_at >= '2025-01-01'
ORDER BY o.created_at DESC
LIMIT 50;

-- BAD: Joining on expressions, filtering late
SELECT *
FROM orders o
INNER JOIN customers c ON LOWER(c.email) = LOWER(o.customer_email)
WHERE YEAR(o.created_at) = 2025;
```

**Rules:**
- Always join on indexed columns (typically primary keys and foreign keys).
- Place the most restrictive `WHERE` conditions on the driving table to reduce the row set early.
- Avoid joining on computed expressions — create a persisted computed column or a functional index if needed.
- When joining many tables, consider whether a subquery or CTE might be clearer and equally performant.

### Pagination Strategies

**Offset-based pagination** (simple but degrades on large offsets):

```sql
SELECT id, name, email
FROM users
WHERE deleted_at IS NULL
ORDER BY created_at DESC
LIMIT 20 OFFSET 1000;
-- Database must scan and discard 1000 rows
```

**Keyset/cursor-based pagination** (performant at any depth):

```sql
-- First page
SELECT id, name, email, created_at
FROM users
WHERE deleted_at IS NULL
ORDER BY created_at DESC, id DESC
LIMIT 20;

-- Next page (use last row's values as cursor)
SELECT id, name, email, created_at
FROM users
WHERE deleted_at IS NULL
  AND (created_at, id) < ('2025-02-01T10:00:00Z', '550e8400-e29b-41d4-a716-446655440000')
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

**Rule:** Use offset-based pagination for admin/back-office UIs with moderate data volumes (< 100k rows). Use keyset pagination for APIs, infinite scrolling, and large datasets.

### Aggregation Best Practices

```sql
-- GOOD: Filter before aggregating
SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS total_spent
FROM orders
WHERE status = 'completed'
  AND created_at >= '2025-01-01'
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_spent DESC;

-- BAD: Aggregating everything then filtering in application code
SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS total_spent
FROM orders
GROUP BY customer_id;
-- Then filtering in PHP/Node/Java... wasted database work
```

### Common Table Expressions (CTEs)

Use CTEs for readability. Be aware that in some databases (PostgreSQL < 12), CTEs act as optimisation fences:

```sql
-- Readable multi-step query
WITH active_customers AS (
    SELECT id, name
    FROM customers
    WHERE status = 'active'
      AND deleted_at IS NULL
),
recent_orders AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    WHERE created_at >= NOW() - INTERVAL '30 days'
    GROUP BY customer_id
)
SELECT ac.id, ac.name, COALESCE(ro.order_count, 0) AS recent_orders
FROM active_customers ac
LEFT JOIN recent_orders ro ON ro.customer_id = ac.id
ORDER BY recent_orders DESC;
```

### Window Functions

Use window functions for ranking, running totals, and per-group calculations without collapsing rows:

```sql
-- Rank orders by total within each customer
SELECT
    customer_id,
    id AS order_id,
    total,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total DESC) AS rank,
    SUM(total) OVER (PARTITION BY customer_id) AS customer_total
FROM orders
WHERE status = 'completed';
```

### Batch Operations

For large data modifications, batch to avoid long locks and transaction log bloat:

```sql
-- Instead of one massive DELETE:
-- DELETE FROM logs WHERE created_at < '2024-01-01';  -- locks millions of rows

-- Batch delete:
DO $$
DECLARE
    rows_deleted INT;
BEGIN
    LOOP
        DELETE FROM logs
        WHERE id IN (
            SELECT id FROM logs
            WHERE created_at < '2024-01-01'
            LIMIT 5000
        );
        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        EXIT WHEN rows_deleted = 0;
        COMMIT;
    END LOOP;
END $$;
```

---

## 6. Transactions

### ACID Properties

| Property | Meaning | Practical Impact |
|---|---|---|
| **Atomicity** | All operations in a transaction succeed or all are rolled back | Partial updates never reach the database |
| **Consistency** | Transaction moves the database from one valid state to another | Constraints are enforced at commit time |
| **Isolation** | Concurrent transactions don't interfere with each other | Determined by the isolation level |
| **Durability** | Committed data survives system failures | Data is persisted to disk on commit |

### Transaction Isolation Levels

| Level | Dirty Reads | Non-Repeatable Reads | Phantom Reads | Use Case |
|---|---|---|---|---|
| `READ UNCOMMITTED` | Yes | Yes | Yes | Almost never — only for dirty analytics on non-critical data |
| `READ COMMITTED` | No | Yes | Yes | **Default for PostgreSQL.** Good for most OLTP workloads |
| `REPEATABLE READ` | No | No | Yes* | Financial calculations, inventory checks within a transaction |
| `SERIALIZABLE` | No | No | No | Critical financial operations, booking systems with strict consistency |

*PostgreSQL's `REPEATABLE READ` also prevents phantom reads (it uses snapshot isolation internally).

**Rule:** Use `READ COMMITTED` by default. Escalate to `REPEATABLE READ` or `SERIALIZABLE` only for specific operations that require stronger guarantees, and handle serialisation failures with retry logic.

### Transaction Best Practices

```sql
-- GOOD: Short, focused transaction
BEGIN;
    UPDATE accounts SET balance = balance - 100.00 WHERE id = 1;
    UPDATE accounts SET balance = balance + 100.00 WHERE id = 2;
    INSERT INTO transactions (from_id, to_id, amount) VALUES (1, 2, 100.00);
COMMIT;
```

**Rules:**
- Keep transactions as short as possible. Long transactions hold locks and block other operations.
- Never perform external I/O (HTTP calls, file operations) inside a transaction.
- Always handle transaction failures: catch exceptions, rollback, and optionally retry.
- Use `SAVEPOINT` for partial rollbacks within a larger transaction when needed.
- Acquire locks in a consistent order across all transactions to prevent deadlocks (e.g., always lock by ascending ID).

### Savepoints

```sql
BEGIN;
    INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
    SAVEPOINT before_items;

    INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 99, 1);
    -- If this fails:
    ROLLBACK TO SAVEPOINT before_items;
    -- Order is still inserted, items are rolled back

COMMIT;
```

---

## 7. Locking Mechanics

### Lock Types

| Lock Type | SQL | Scope | Behaviour |
|---|---|---|---|
| **Row-level shared (FOR SHARE)** | `SELECT ... FOR SHARE` | Row | Other transactions can read but not modify the row |
| **Row-level exclusive (FOR UPDATE)** | `SELECT ... FOR UPDATE` | Row | Other transactions cannot read (with FOR UPDATE) or modify the row |
| **Table-level** | `LOCK TABLE ... IN <mode> MODE` | Table | Applies to the entire table — use sparingly |
| **Advisory locks** | `pg_advisory_lock(key)` | Application-defined | Application-level coordination, not tied to specific rows |

### Optimistic Locking

Optimistic locking assumes conflicts are rare. It checks for conflicts at write time using a version column:

```sql
-- Schema
ALTER TABLE products ADD COLUMN version INT NOT NULL DEFAULT 1;

-- Read: fetch current version
SELECT id, name, price, stock, version FROM products WHERE id = 42;
-- Application receives: version = 3

-- Update: include version check
UPDATE products
SET stock = stock - 1, version = version + 1, updated_at = NOW()
WHERE id = 42 AND version = 3;

-- If 0 rows affected → another transaction modified the row → handle conflict (retry or error)
```

**When to use:**
- Low contention (concurrent writes to the same row are rare)
- Read-heavy workloads
- User-facing forms where edits happen seconds/minutes apart
- Distributed systems where holding database locks across requests is impractical

**ORM support:**

| ORM | Implementation |
|---|---|
| **TypeORM** | `@VersionColumn()` decorator |
| **Prisma** | Manual implementation via `version` field and conditional update |
| **Doctrine (PHP)** | `@ORM\Version` annotation on an integer or datetime column |
| **Eloquent (Laravel)** | Manual implementation or `laravel-optimistic-locking` package |
| **Entity Framework (.NET)** | `[Timestamp]` attribute or `IsRowVersion()` in Fluent API |
| **Hibernate (Java)** | `@Version` annotation |
| **GORM (Go)** | Built-in optimistic locking with `gorm:"column:version"` tag |

### Pessimistic Locking

Pessimistic locking assumes conflicts are likely. It acquires locks at read time to prevent concurrent modification:

```sql
-- Lock the row immediately — other transactions block until this transaction commits
BEGIN;
    SELECT * FROM inventory WHERE product_id = 42 FOR UPDATE;
    -- ... perform business logic ...
    UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 42;
COMMIT;
```

**Variants:**

```sql
-- FOR UPDATE SKIP LOCKED — skip already-locked rows (useful for job queues)
SELECT id, payload
FROM job_queue
WHERE status = 'pending'
ORDER BY created_at
LIMIT 1
FOR UPDATE SKIP LOCKED;

-- FOR UPDATE NOWAIT — fail immediately if the row is locked (instead of blocking)
SELECT * FROM inventory WHERE product_id = 42 FOR UPDATE NOWAIT;
-- Throws an error immediately if the row is locked by another transaction
```

**When to use:**
- High contention (concurrent writes to the same row are likely)
- Critical sections that must not have conflicts (inventory decrements, booking seats)
- Short-lived transactions where holding a lock briefly is acceptable
- Job queues and task processing (`SKIP LOCKED`)

### Optimistic vs Pessimistic — Decision Guide

| Factor | Optimistic | Pessimistic |
|---|---|---|
| Conflict frequency | Low (< 1% of operations) | High or unpredictable |
| Read/write ratio | Read-heavy | Write-heavy on contested resources |
| Transaction duration | Can be long (no locks held) | Must be short (locks block others) |
| Failure handling | Retry on conflict | Block until lock is released |
| Distributed systems | Preferred (no lock coordination needed) | Difficult (requires sticky sessions or distributed locks) |
| User experience | May show "conflict, please retry" | May show loading/waiting if contention is high |

### Deadlock Prevention

1. **Consistent lock ordering:** Always acquire locks in the same order (e.g., by ascending primary key).
2. **Short transactions:** Minimise the time locks are held.
3. **Lock timeout:** Set `lock_timeout` to avoid indefinite blocking.
4. **Detect and retry:** Handle deadlock exceptions and retry the transaction.

```sql
-- PostgreSQL: set a lock timeout
SET lock_timeout = '5s';

-- MySQL: set innodb_lock_wait_timeout per session
SET innodb_lock_wait_timeout = 5;
```

---

## 8. Query Debugging with EXPLAIN

### EXPLAIN Basics

```sql
-- Show the query plan (does not execute the query)
EXPLAIN SELECT * FROM orders WHERE customer_id = 42;

-- Show the query plan AND execute the query (shows actual timings)
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 42;

-- Full diagnostic output (PostgreSQL)
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, c.name
FROM orders o
JOIN customers c ON c.id = o.customer_id
WHERE o.status = 'active'
ORDER BY o.created_at DESC
LIMIT 20;
```

### Reading EXPLAIN Output

Key fields to examine:

| Field | What It Tells You |
|---|---|
| **Seq Scan** | Full table scan — often a sign of missing index |
| **Index Scan** | Using an index to find rows — this is what you want |
| **Index Only Scan** | Data served entirely from the index (covering index) — best case |
| **Bitmap Index Scan** | Index used to build a bitmap, then table scanned — common for OR conditions / multiple indexes |
| **Nested Loop** | For each row in outer table, scan inner table — efficient for small outer sets |
| **Hash Join** | Build hash table from one side, probe with the other — efficient for large equijoins |
| **Merge Join** | Both sides sorted, then merged — efficient when both inputs are pre-sorted |
| **Sort** | Explicit sort operation — check if an index could eliminate this |
| **Rows** (estimated) | Planner's estimate of rows processed at this step |
| **Actual Rows** (ANALYZE only) | Real number of rows processed — compare with estimated to find planner misestimates |
| **Buffers** (ANALYZE + BUFFERS) | Shared/local buffers hit (cache) vs read (disk) — high reads = cache miss, consider prewarming or more memory |
| **Cost** | Arbitrary units comparing relative cost of plan steps — lower is better |

### Common Performance Problems and Fixes

| EXPLAIN Symptom | Likely Cause | Fix |
|---|---|---|
| `Seq Scan` on large table | Missing index | Add appropriate index |
| `Seq Scan` despite index existing | Query uses a function on the indexed column | Rewrite query or create a functional index |
| Estimated rows ≠ actual rows (off by 10x+) | Stale statistics | Run `ANALYZE table_name;` |
| `Sort` with high cost | No index matching `ORDER BY` | Add index covering sort columns |
| `Nested Loop` with large inner table | Planner chose wrong join strategy | Verify indexes on join columns; consider increasing `work_mem` |
| `Hash Join` spilling to disk | `work_mem` too small for the hash table | Increase `work_mem` for the session or globally |
| High `Buffers: read` count | Data not in cache | Increase `shared_buffers` or ensure table fits in memory; check for bloated tables |

### Iterative Query Optimisation Process

```
Query optimisation process:
1. [ ] Identify the slow query (application logs, pg_stat_statements, slow query log)
2. [ ] Run EXPLAIN ANALYZE on the query
3. [ ] Identify the most expensive node in the plan
4. [ ] Determine root cause (missing index, bad statistics, inefficient join, sort)
5. [ ] Apply ONE fix at a time
6. [ ] Re-run EXPLAIN ANALYZE and compare
7. [ ] Repeat until acceptable performance is reached
8. [ ] Verify the fix doesn't degrade other queries
```

### MySQL-Specific EXPLAIN Notes

```sql
-- MySQL uses a different EXPLAIN format
EXPLAIN SELECT * FROM orders WHERE customer_id = 42;

-- Key MySQL EXPLAIN columns:
-- type: ALL (full scan) → index → range → ref → eq_ref → const → system (best to worst)
-- possible_keys: indexes the optimiser considered
-- key: index actually used
-- rows: estimated rows scanned
-- Extra: "Using filesort", "Using temporary" are red flags

-- MySQL 8.0+ supports EXPLAIN ANALYZE:
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 42;
```

---

## 9. SQL Writing Best Practices

### Formatting Standards

```sql
-- GOOD: Readable, consistent formatting
SELECT
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    COUNT(o.id) AS order_count,
    COALESCE(SUM(o.total), 0) AS lifetime_value
FROM users u
LEFT JOIN orders o ON o.customer_id = u.id
    AND o.status = 'completed'
WHERE u.deleted_at IS NULL
  AND u.created_at >= '2025-01-01'
GROUP BY u.id, u.email, u.first_name, u.last_name
HAVING COUNT(o.id) > 0
ORDER BY lifetime_value DESC
LIMIT 50;
```

**Formatting rules:**
- Keywords in UPPERCASE: `SELECT`, `FROM`, `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`
- One column per line in `SELECT` list for queries with more than 3 columns
- `AND`/`OR` at the beginning of the line, indented
- Table aliases: short but meaningful (`u` for `users`, `o` for `orders`)
- Align `JOIN ... ON` conditions consistently
- Always terminate statements with `;`

### Security — Preventing SQL Injection

**Never concatenate user input into SQL strings.** Always use parameterised queries:

```sql
-- GOOD: Parameterised (prepared statement)
-- PostgreSQL / Node.js
SELECT * FROM users WHERE email = $1;

-- MySQL / PHP
SELECT * FROM users WHERE email = ?;
```

**ORM equivalents (all safe by default):**

```typescript
// TypeORM — safe
const user = await userRepository.findOne({ where: { email: userInput } });

// Prisma — safe
const user = await prisma.user.findUnique({ where: { email: userInput } });
```

```php
// Doctrine — safe
$user = $repository->findOneBy(['email' => $userInput]);

// Eloquent — safe
$user = User::where('email', $userInput)->first();
```

```csharp
// Entity Framework — safe
var user = await context.Users.FirstOrDefaultAsync(u => u.Email == userInput);
```

```java
// Hibernate — safe
User user = session.createQuery("FROM User u WHERE u.email = :email", User.class)
    .setParameter("email", userInput)
    .uniqueResult();
```

```go
// GORM — safe
var user User
db.Where("email = ?", userInput).First(&user)
```

**DANGER: Raw queries with string concatenation:**

```typescript
// TypeORM — DANGEROUS if not parameterised
const users = await dataSource.query(`SELECT * FROM users WHERE email = '${userInput}'`); // SQL INJECTION!

// TypeORM — SAFE raw query
const users = await dataSource.query('SELECT * FROM users WHERE email = $1', [userInput]);
```

### NULL Handling

```sql
-- WRONG: = NULL never matches
SELECT * FROM users WHERE deleted_at = NULL;

-- CORRECT: Use IS NULL / IS NOT NULL
SELECT * FROM users WHERE deleted_at IS NULL;

-- Use COALESCE for default values
SELECT COALESCE(u.nickname, u.first_name, 'Anonymous') AS display_name
FROM users u;

-- NULL-safe comparison (when comparing two nullable columns)
-- PostgreSQL:
SELECT * FROM t1 JOIN t2 ON t1.val IS NOT DISTINCT FROM t2.val;
-- MySQL:
SELECT * FROM t1 JOIN t2 ON t1.val <=> t2.val;
```

### UPSERT Patterns

```sql
-- PostgreSQL: INSERT ... ON CONFLICT
INSERT INTO products (sku, name, price, updated_at)
VALUES ('WIDGET-001', 'Widget', 19.99, NOW())
ON CONFLICT (sku)
DO UPDATE SET
    name = EXCLUDED.name,
    price = EXCLUDED.price,
    updated_at = NOW();

-- MySQL: INSERT ... ON DUPLICATE KEY UPDATE
INSERT INTO products (sku, name, price, updated_at)
VALUES ('WIDGET-001', 'Widget', 19.99, NOW())
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    price = VALUES(price),
    updated_at = NOW();
```

### Avoiding Common Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| `SELECT *` | Fetches unnecessary columns, breaks when schema changes | Explicitly list needed columns |
| `N+1 queries` | 1 query to fetch parents + N queries for children | Use `JOIN` or batch loading (`WHERE id IN (...)`) |
| `WHERE column != value` with index | `!=` / `<>` cannot use index efficiently | Restructure as positive condition or check if full scan is acceptable |
| `LIKE '%value%'` | Leading wildcard prevents index use | Use full-text search (`tsvector` in PostgreSQL, `FULLTEXT` in MySQL) |
| `ORDER BY RAND()` | Scans and sorts entire table | Use a sampled approach: `WHERE id >= (SELECT FLOOR(RANDOM() * MAX(id)) FROM table) LIMIT 1` |
| Implicit type conversion | `WHERE varchar_col = 123` may skip index | Match types explicitly: `WHERE varchar_col = '123'` |
| Correlated subquery in SELECT | Executes subquery for every row | Rewrite as `JOIN` or window function |
| Missing `LIMIT` on exploratory queries | Accidentally fetching millions of rows | Always add `LIMIT` when exploring data |

---

## 10. ORM Integration Guidelines

### ORM Selection by Stack

| Stack | Primary ORM | Alternative |
|---|---|---|
| **PHP (Symfony)** | Doctrine ORM | — |
| **PHP (Laravel)** | Eloquent ORM | — |
| **Node.js (NestJS)** | TypeORM or MikroORM | Prisma |
| **Node.js (General)** | Prisma | TypeORM, Drizzle |
| **.NET** | Entity Framework Core | Dapper (micro-ORM for raw SQL) |
| **Java (Spring)** | Hibernate / Spring Data JPA | jOOQ (for SQL-first approach) |
| **Go** | GORM | sqlx (for raw SQL), Ent |

### ORM Best Practices

**1. Always review generated SQL.**
Enable query logging in development to inspect what the ORM generates. Inefficient ORM usage can produce catastrophic queries.

```typescript
// TypeORM: enable query logging
const dataSource = new DataSource({
    logging: ['query', 'error'],
    // ...
});

// Prisma: enable query logging
const prisma = new PrismaClient({
    log: ['query', 'warn', 'error'],
});
```

```php
// Doctrine: enable SQL logger
$configuration->setSQLLogger(new \Doctrine\DBAL\Logging\EchoSQLLogger());

// Laravel: enable query log
DB::enableQueryLog();
// ... run queries ...
dd(DB::getQueryLog());
```

**2. Solve N+1 queries with eager loading.**

```typescript
// TypeORM — eager loading with relations
const orders = await orderRepository.find({
    relations: ['customer', 'items', 'items.product'],
    where: { status: 'active' },
});

// Prisma — include related data
const orders = await prisma.order.findMany({
    where: { status: 'active' },
    include: {
        customer: true,
        items: { include: { product: true } },
    },
});
```

```php
// Eloquent — eager loading
$orders = Order::with(['customer', 'items.product'])
    ->where('status', 'active')
    ->get();

// Doctrine — DQL with joins
$orders = $em->createQuery('
    SELECT o, c, i, p
    FROM App\Entity\Order o
    JOIN o.customer c
    JOIN o.items i
    JOIN i.product p
    WHERE o.status = :status
')->setParameter('status', 'active')
  ->getResult();
```

```csharp
// Entity Framework — eager loading
var orders = await context.Orders
    .Include(o => o.Customer)
    .Include(o => o.Items)
        .ThenInclude(i => i.Product)
    .Where(o => o.Status == "active")
    .ToListAsync();
```

```java
// Hibernate / Spring Data JPA — fetch join
@Query("SELECT o FROM Order o " +
       "JOIN FETCH o.customer " +
       "JOIN FETCH o.items i " +
       "JOIN FETCH i.product " +
       "WHERE o.status = :status")
List<Order> findActiveWithDetails(@Param("status") String status);
```

```go
// GORM — preload
var orders []Order
db.Preload("Customer").Preload("Items.Product").
    Where("status = ?", "active").
    Find(&orders)
```

**3. Use raw SQL for complex queries.**
When ORM abstractions produce inefficient SQL or cannot express the query you need, drop to raw SQL:

```typescript
// TypeORM — raw query
const results = await dataSource.query(`
    SELECT u.id, u.email, COUNT(o.id) AS order_count
    FROM users u
    LEFT JOIN orders o ON o.customer_id = u.id AND o.status = 'completed'
    WHERE u.deleted_at IS NULL
    GROUP BY u.id, u.email
    HAVING COUNT(o.id) > 5
    ORDER BY order_count DESC
    LIMIT $1
`, [50]);

// Prisma — raw query
const results = await prisma.$queryRaw`
    SELECT u.id, u.email, COUNT(o.id) AS order_count
    FROM users u
    LEFT JOIN orders o ON o.customer_id = u.id AND o.status = 'completed'
    WHERE u.deleted_at IS NULL
    GROUP BY u.id, u.email
    HAVING COUNT(o.id) > 5
    ORDER BY order_count DESC
    LIMIT ${50}
`;
```

**4. ORM Migration Workflow.**
- Generate migrations from entity/model changes, never edit the database directly.
- Review generated migration SQL before applying — ORMs sometimes generate suboptimal DDL.
- Test migrations against a copy of production data to catch issues (data truncation, long-running locks).

**5. Repository Pattern with ORMs.**
Keep all database queries in repository classes. Services should never directly use the ORM's query builder or entity manager:

```
Service → Repository Interface → Repository Implementation (uses ORM)
```

This keeps business logic decoupled from the data access mechanism and makes testing easier (mock the repository interface).

---

## 11. Database Maintenance & Monitoring

### Statistics and Vacuuming (PostgreSQL)

```sql
-- Update table statistics for the planner
ANALYZE orders;

-- Update statistics for all tables
ANALYZE;

-- Check for table bloat (dead tuples)
SELECT relname, n_dead_tup, n_live_tup,
       ROUND(n_dead_tup::NUMERIC / NULLIF(n_live_tup, 0) * 100, 2) AS dead_pct
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

### Slow Query Identification

```sql
-- PostgreSQL: enable pg_stat_statements extension
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Find slowest queries by total time
SELECT
    calls,
    ROUND(total_exec_time::NUMERIC, 2) AS total_ms,
    ROUND(mean_exec_time::NUMERIC, 2) AS mean_ms,
    ROUND(max_exec_time::NUMERIC, 2) AS max_ms,
    LEFT(query, 200) AS query_preview
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;
```

```sql
-- MySQL: enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- queries taking > 1 second
```

### Connection Pooling

- Always use connection pooling in production. Direct connections are expensive to create.
- PostgreSQL: use PgBouncer or built-in pooling in the ORM/driver.
- MySQL: use ProxySQL or driver-level pooling.
- Set pool size based on: `pool_size = (core_count * 2) + effective_spindle_count` (formula from PostgreSQL wiki).
- Monitor for connection exhaustion — set `max_connections` appropriately and alert when pool utilisation exceeds 80%.

---

## Implementation Procedure

When writing SQL or designing a database schema, follow this workflow:

```
Implementation progress:
- [ ] Step 1: Understand the data requirements
- [ ] Step 2: Design the schema (entities, relationships, constraints)
- [ ] Step 3: Choose normalisation level and document any denormalisation decisions
- [ ] Step 4: Define indexes based on expected query patterns
- [ ] Step 5: Write the migration(s)
- [ ] Step 6: Write the queries (raw SQL or ORM)
- [ ] Step 7: Run EXPLAIN ANALYZE on critical queries
- [ ] Step 8: Implement appropriate locking and transaction strategy
- [ ] Step 9: Review ORM-generated SQL (if applicable)
- [ ] Step 10: Test with realistic data volumes
```

**Step 1: Understand the data requirements**
Read the task description and acceptance criteria. Identify the entities, their attributes, and the relationships between them. Clarify cardinality (one-to-many, many-to-many).

**Step 2: Design the schema**
Create tables following the naming conventions and standard columns defined in this skill. Define relationships with appropriate foreign keys and ON DELETE actions.

**Step 3: Choose normalisation level**
Target 3NF by default. Document any intentional denormalisation with a clear justification tied to measured performance needs or snapshot requirements.

**Step 4: Define indexes**
Identify the primary query patterns and create indexes to support them. Index all foreign keys. Create composite indexes for multi-column filters and sorts.

**Step 5: Write the migration(s)**
Generate migration files with both `up` and `down` methods. Review the generated DDL before applying.

**Step 6: Write the queries**
Write queries following the performance and formatting rules in this skill. Use parameterised queries. Avoid `SELECT *`.

**Step 7: Run EXPLAIN ANALYZE**
Verify critical query plans. Look for sequential scans on large tables, missing indexes, and planner misestimates.

**Step 8: Implement locking and transaction strategy**
Choose optimistic or pessimistic locking based on the contention profile. Define transaction boundaries and appropriate isolation levels.

**Step 9: Review ORM-generated SQL**
Enable query logging and inspect generated queries for N+1 problems, unnecessary joins, or missing eager loading.

**Step 10: Test with realistic data volumes**
Seed the development database with production-scale data. Verify that queries perform within acceptable time limits under load.

## Connected Skills

- `backend-api-development` — for API layer patterns, repository pattern, and database handling guidance
- `architecture-designing` — for designing data models as part of broader system architecture
- `code-reviewing` — for validating SQL quality, index coverage, and query performance
- `technical-context-discovering` — for establishing database conventions and existing patterns before designing
