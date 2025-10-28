---
description: "Generate a well-formatted commit message based on staged changes."
tools: [
   'search/codebase', 
   'runCommands', 
   'runTasks', 
   'atlassian/*', 
   'think', 
   'problems', 
   'changes', 
   'githubRepo', 
   'extensions'
   ]
mode: agent
---

Your goal is to analyze the staged changes in the repository and generate a comprehensive, well-formatted commit message that follows best practices and any existing commit conventions.

## Process

1. **Check for existing commit conventions:**
   - Look for `.commitlintrc`, `.commitlintrc.json`, `.commitlintrc.js`, or `commitlint.config.js`
   - Check `package.json` for commitlint configuration
   - If commitlint is configured, follow its rules (e.g., Conventional Commits format)
   - If no commitlint found, use standard Git best practices

2. **Analyze staged changes:**
   - Review all staged files and their changes
   - Identify the scope and impact of changes
   - Categorize changes by type (feature, fix, refactor, docs, etc.)

3. **Generate commit message structure:**

Common types:

- `feat`: A new feature, changes to prompts or chat modes
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (formatting, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature

**If commitlint with Conventional Commits is detected:**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**If no commitlint (standard Git best practices):**

```
<Subject line: common type:, imperative mood, max 72 chars>

<Body: explain what and why, wrap at 72 chars>

<Footer: references, breaking changes>
```

4. **Commit message guidelines:**
   - **Subject line:**
     - State the type of change
     - Use imperative mood ("Add feature" not "Added feature")
     - Don't end with a period
     - Capitalize first letter
     - Be concise but descriptive
     - Max 72 characters
   - **Body (if needed):**
     - Explain WHAT changed and WHY (not HOW)
     - Wrap at 72 characters
     - Separate from subject with blank line
     - Use bullet points for multiple changes
   - **Footer (if applicable):**
     - Reference issue numbers (e.g., "Fixes #123", "Closes #456")
     - Note breaking changes (e.g., "BREAKING CHANGE: ...")
     - Co-authored-by for pair programming

5. **Present the commit message:**
   - Show the generated commit message in a code block
   - Explain your reasoning
   - Ask if user wants to proceed with the commit or make changes

## Examples

### Conventional Commits (with commitlint):

```
feat(auth): add OAuth2 authentication support

Implement OAuth2 flow for third-party authentication providers.
Includes Google and GitHub providers with configurable redirect URIs.

- Add OAuth2Service for handling authentication flow
- Create provider configuration system
- Add redirect URI validation
- Update user model to support external auth

Closes #234
```

### Standard Git format:

```
Add OAuth2 authentication support

Implement OAuth2 flow for third-party authentication providers
including Google and GitHub. The new authentication system allows
users to sign in using their existing accounts from these providers.

Changes include:
- OAuth2Service for handling authentication flow
- Provider configuration system
- Redirect URI validation
- Updated user model to support external authentication

This resolves the authentication issues reported in issue #234.
```

## Important Notes

- Always check the current git status before generating the commit message
- If there are no staged changes, inform the user and ask if they want to stage files first
- Respect the project's existing commit message patterns by reviewing recent commit history
- If the changes are too large or diverse, suggest splitting into multiple commits
- Ensure compliance with any detected commit message validation tools

After generating the commit message, ask the user if they want to:

1. Proceed with the commit using this message
2. Edit the message before committing
3. Cancel and make more changes
