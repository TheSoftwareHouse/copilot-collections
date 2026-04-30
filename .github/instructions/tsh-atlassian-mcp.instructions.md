---
description: 'Correct tool call patterns for Atlassian MCP (Jira and Confluence). Prevents wasted retries on parameter errors and reduces token usage from verbose API responses.'
applyTo: '.github/**'
---

# Atlassian MCP Tool Usage Patterns

## Session Setup — Get `cloudId` First

Every Atlassian MCP tool requires a `cloudId`. Fetch it **once** at the start of any Jira/Confluence workflow and reuse it for all subsequent calls:

```
mcp_atlassian_getAccessibleAtlassianResources()
→ returns array of resources with { id, url, name }
→ use the `id` field as `cloudId` for all other calls
```

If multiple resources are returned, ask the user which one to use.

## Creating Jira Issues and Sub-Tasks

Use `mcp_atlassian_createJiraIssue` with these **exact parameter names**:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cloudId` | Yes | From `getAccessibleAtlassianResources` |
| `projectKey` | Yes | e.g., `"HIB"` |
| `issueTypeName` | Yes | Exact name from project metadata, e.g., `"Sub task"`, `"Task"`, `"Bug"` |
| `summary` | Yes | Issue title |
| `description` | No | Issue body (markdown). Put the **full content** here — do not use a placeholder and add content later as a comment. |
| `parent` | For sub-tasks | Parent issue key, e.g., `"HIB-186"` |

### Common mistakes to avoid

- Do NOT use `parentKey` — the correct parameter is **`parent`**
- Do NOT use `projectIdOrKey` — the parameter is `projectKey`
- Do NOT use `issueTypeId` — the parameter is `issueTypeName`
- Do NOT omit `cloudId` — it is always required
- Do NOT guess issue type names — fetch them first with `getJiraProjectIssueTypesMetadata`
- Do NOT use a placeholder description and add content as a comment — put the full description in the `description` parameter when creating the issue

### Recommended sequence for sub-task creation

1. `getAccessibleAtlassianResources` → get `cloudId`
2. `getJiraProjectIssueTypesMetadata(cloudId, projectIdOrKey)` → get exact subtask type name
3. `createJiraIssue(cloudId, projectKey, issueTypeName, summary, description, parent)` → create the sub-task with full description

Cache the `cloudId` and issue type names for the session — do not re-fetch them for each sub-task.

## Fetching Jira Issues — Token-Efficient Extraction

When fetching a ticket with `getJiraIssue`, the response contains extensive metadata (avatar URLs, status URLs, project metadata, user details). **Do not repeat the full response in conversation.**

After fetching, immediately extract and summarize only these fields:
- **Summary** — issue title
- **Description** — ticket body (contains AC)
- **Status** — current status name
- **Issue type** — task, bug, story, etc.
- **Parent key** — if it's a sub-task

Discard: avatar URLs, self links, status category metadata, project avatar URLs, user account IDs, timezone info, and other Atlassian infrastructure fields.

Present the extracted information as a brief summary to the user, not as raw JSON.

## Searching Jira Issues

Use `mcp_atlassian_searchJiraIssuesUsingJql` with:

| Parameter | Required |
|-----------|----------|
| `cloudId` | Yes |
| `jql` | Yes |

Prefer a single broad JQL query over multiple narrow queries. Filter results in-memory rather than making separate API calls for each category.

### Pagination

The search tool returns a **limited number of results per call** (typically 10-25). If the total count exceeds the returned results, you MUST paginate to get all data.

**Pagination technique:** Add `AND key < "{lastKeyFromPreviousPage}"` to the JQL to fetch the next page:

1. First call: `project = HIB AND type = Bug ORDER BY key DESC`
2. If result shows more items exist, note the last key returned (e.g., `HIB-208`)
3. Next call: `project = HIB AND type = Bug AND key < "HIB-208" ORDER BY key DESC`
4. Repeat until no more results are returned

**Always check if results are complete.** If the response indicates a `total` higher than the number of returned issues, paginate. Do NOT generate reports or analysis from partial data — fetch all pages first.

## Constructing Jira URLs for Links

When generating reports (HTML, Confluence, Jira ticket descriptions), always link to Jira rather than showing plain text. Derive the base URL from the `getAccessibleAtlassianResources` response (the `url` field, e.g., `https://headstart.atlassian.net`).

| Link target | URL pattern |
|-------------|-------------|
| Single issue | `{baseUrl}/browse/{issueKey}` |
| Project board | `{baseUrl}/jira/software/projects/{projectKey}/board` |
| JQL filter (issue navigator) | `{baseUrl}/issues/?jql={urlEncodedJql}` |

**In HTML reports:**
- KPI card values (open bugs count, total count, etc.) → wrap in `<a href="...">` linking to the JQL filter that produces that count.
- Bug keys in tables → link to `{baseUrl}/browse/{key}`.
- JQL query shown in methodology → render as clickable link to the issue navigator.
- Project name in header → link to the project board.

## Editing Jira Issues

Use `mcp_atlassian_editJiraIssue` to update an existing issue's fields (e.g., description):

| Parameter | Required |
|-----------|----------|
| `cloudId` | Yes |
| `issueIdOrKey` | Yes |
| `description` | No — field to update |
| `summary` | No — field to update |

## Adding Comments to Jira Issues

Use `mcp_atlassian_addCommentToJiraIssue` with:

| Parameter | Required |
|-----------|----------|
| `cloudId` | Yes |
| `issueIdOrKey` | Yes |
| `commentBody` | Yes |

## Confluence — Creating Pages

Use `mcp_atlassian_createConfluencePage` with these **exact parameter names**:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cloudId` | Yes | From `getAccessibleAtlassianResources` |
| `spaceId` | Yes | **Numeric** space ID (e.g., `"5294817321"`). NOT the space key. |
| `parentId` | No | Numeric page ID of the parent page (for subpages) |
| `title` | Yes | Page title |
| `body` | Yes | Page body in **ADF JSON** format (not markdown, not storage/XHTML) |

### Common mistakes to avoid

- Do NOT use the space **key** (e.g., `"Hiber"`) as `spaceId` — it must be a **numeric** ID
- Do NOT use markdown or XHTML for `body` — Confluence Cloud API requires **ADF (Atlassian Document Format)** JSON
- Do NOT skip `parentId` when creating subpages — without it the page lands at the space root

### Resolving a Confluence Space's Numeric `spaceId`

`getConfluenceSpaces` returns only the first 25 spaces with **no pagination support**. If the target space is not in the first batch, you cannot page through results.

**Primary method — resolve via `getConfluencePage`:**

1. Obtain the ID of **any page** in the target space (from a URL the user provides, or from a `searchConfluenceUsingCql` result)
2. Call `getConfluencePage(cloudId, pageId)` — the response **directly includes `spaceId`** as a top-level field
3. Use that `spaceId` for all subsequent page creation/update calls

This is the simplest and most reliable approach.

**Fallback — resolve via ARI fetch** (only if `getConfluencePage` does not return `spaceId` for some reason):

1. Call `mcp_atlassian_fetch(url: "ari:cloud:confluence:{cloudId}:page/{pageId}")`
2. The response includes `metadata.spaceId`

Cache the resolved `spaceId` for the session — do not re-fetch it for each page creation.

### Extracting Page IDs from Confluence URLs

When a user provides a Confluence URL, extract the **numeric page ID** from it:

```
https://{instance}.atlassian.net/wiki/spaces/{spaceKey}/pages/{pageId}/{title}
```

Example: `https://headstart.atlassian.net/wiki/spaces/Hiber/pages/5950242829/Regression`
→ pageId = `5950242829`

Use the extracted `pageId` as:
- `parentId` when creating subpages
- Input for `getConfluencePage` to resolve `spaceId`
- `pageId` when fetching or updating pages

### Recommended sequence for Confluence page creation

1. `getAccessibleAtlassianResources` → get `cloudId`
2. Get page ID using **one of**:
   - **User provides a URL** → extract `pageId` from the path (`/pages/{pageId}/`)
   - **User provides space name + page title** → use `searchConfluenceUsingCql(cloudId, cql: 'space = "{spaceKey}" AND title = "{pageTitle}"')` → extract `pageId` from the result
3. `getConfluencePage(cloudId, pageId)` → read `spaceId` from the response
4. Use the `pageId` as `parentId` for subpages
5. `createConfluencePage(cloudId, spaceId, parentId, title, body)` → create the page with full ADF body

The user should never need to provide numeric IDs — they provide human-readable identifiers (URL, space name, page title) and the agent resolves the rest.

## Confluence — Updating Pages

Use `mcp_atlassian_updateConfluencePage` with:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cloudId` | Yes | From `getAccessibleAtlassianResources` |
| `pageId` | Yes | Numeric page ID to update |
| `title` | Yes | Page title (can be same as existing) |
| `body` | Yes | Full page body in **ADF JSON** format (replaces existing content) |
| `version` | Yes | New version number (current version + 1). Fetch current version first with `getConfluencePage`. |

### Common mistakes to avoid

- Do NOT omit `version` — the API requires an incremented version number
- The `body` replaces the entire page content — there is no append/patch mode

## Confluence — Fetching Pages

Use `mcp_atlassian_getConfluencePage` with:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cloudId` | Yes | From `getAccessibleAtlassianResources` |
| `pageId` | Yes | Numeric page ID |

Returns page title, body (in ADF or storage format), version number, and metadata.

## Confluence — Searching with CQL

Use `mcp_atlassian_searchConfluenceUsingCql` with:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `cloudId` | Yes | From `getAccessibleAtlassianResources` |
| `cql` | Yes | Confluence Query Language string |

Useful CQL patterns:
- `space = "Hiber" AND title = "Regression"` — find pages by title in a space
- `space = "Hiber" AND ancestor = 5521768451` — find all descendants of a page
- `space = "Hiber" AND type = page AND label = "qa"` — find pages with a label

Note: CQL uses the **space key** (e.g., `"Hiber"`) — this is one of the few places where the space key (not numeric ID) is correct.

## Format Differences — Jira vs Confluence

| Tool | Body format |
|------|-------------|
| `createJiraIssue` — `description` | **Markdown** |
| `addCommentToJiraIssue` — `commentBody` | **Markdown** |
| `editJiraIssue` — `description` | **Markdown** |
| `createConfluencePage` — `body` | **ADF JSON** |
| `updateConfluencePage` — `body` | **ADF JSON** |

Do NOT mix these up. Jira accepts markdown strings. Confluence requires valid ADF (Atlassian Document Format) JSON with `{"type":"doc","version":1,"content":[...]}` structure.
