# Copilot Configurations

This repository contains configurations and prompts for GitHub Copilot.

## Usage in External Projects

To use these shared configurations in your own projects, add the following to your project's `.vscode/settings.json`:

```json
{
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    "../copilot-configurations/.github/prompts": true
  },
  "chat.modeFilesLocations": {
    ".github/chatmodes": true,
    "../copilot-configurations/.github/chatmodes": true
  },
  "github.copilot.chat.agent.thinkingTool": true //We use it in chatmodes. You can turn on in user configuration
}
```

**Setup steps:**

1. Clone this repository next to your project directory:

   ```bash
   # If your project is at ~/Projects/my-project
   cd ~/Projects
   git clone <this-repo-url> copilot-configurations
   ```

2. Your directory structure should look like:

   ```
   Projects/
   ├── my-project/
   │   └── .vscode/
   │       └── settings.json
   └── copilot-configurations/
       └── .github/
           ├── prompts/
           └── chatmodes/
   ```

3. Add the configuration above to your project's `.vscode/settings.json`

4. Restart VS Code or reload the window to apply the changes

This will make all prompts and chat modes from this repository available in your project, along with your project-specific configurations.

## Prerequisites

This project uses [Mise](https://mise.jdx.dev/) for managing development tools and dependencies.

### Installing Mise

If you don't have Mise installed, you can install it using one of the following methods:

**macOS (Homebrew):**

```bash
brew install mise
```

**Using curl:**

```bash
curl https://mise.run | sh
```

After installation, add Mise to your shell:

**For Zsh (add to `~/.zshrc`):**

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
```

**For Bash (add to `~/.bashrc`):**

```bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

## Getting Started

### 1. Install Dependencies

Once you have Mise installed, navigate to the project directory and run:

```bash
mise install
```

This will install Node.js (LTS version) from `.mise.toml`.

Then install npm packages:

```bash
npm install
```

This will install the following devDependencies from `package.json`:

- Prettier (for formatting)
- Husky (for git hooks)
- lint-staged (for running tasks on staged files)

### 2. Set Up Git Hooks

After installing dependencies, set up Husky git hooks:

```bash
mise run setup-husky
```

This will configure automatic formatting before each commit.

### 3. Trust the Configuration

When you first run `mise install`, you may be prompted to trust the configuration files in this directory. Type `Yes` to proceed.

## Available Commands

You can run formatting tasks either through Mise or npm scripts:

### Formatting

**Format all files:**

```bash
mise run format
# or
npm run format
```

**Check formatting (without making changes):**

```bash
mise run format-check
# or
npm run format:check
```

**Format only Markdown files:**

```bash
mise run format-md
# or
npm run format:md
```

### Git Hooks

**Set up Husky (one-time setup):**

```bash
mise run setup-husky
```

**Automatic pre-commit formatting:**

Once Husky is set up, files will be automatically formatted before each commit. The pre-commit hook will:

1. Run `lint-staged` on staged files
2. Format them using Prettier
3. Add the formatted files back to the commit

If you want to bypass the pre-commit hook (not recommended), you can use:

```bash
git commit --no-verify
```

## Project Structure

```
.
├── .github/
│   └── prompts/          # GitHub Copilot prompts
│   └── chatmodes/        # GitHub Copilot chatmodes
├── .husky/               # Husky git hooks
│   └── pre-commit        # Pre-commit hook script
├── .editorconfig         # Editor configuration
├── .mise.toml            # Mise tool and task configuration
├── .prettierrc.json      # Prettier formatting rules
├── .prettierignore       # Files to exclude from formatting
├── .lintstagedrc.json    # lint-staged configuration
├── package.json          # npm package configuration
└── README.md             # This file
```

## Configuration Files

### `.mise.toml`

Defines Node.js version and task shortcuts for this project. Tasks delegate to npm scripts for actual execution.

### `package.json`

npm package configuration including devDependencies (Prettier, Husky, lint-staged) and scripts for formatting tasks.

### `.editorconfig`

Ensures consistent coding styles across different editors and IDEs.

### `.prettierrc.json`

Configuration for Prettier, optimized for Markdown and other file types.

### `.lintstagedrc.json`

Configuration for lint-staged, which runs Prettier on staged files before committing.

### `.husky/pre-commit`

Git pre-commit hook that automatically runs lint-staged to format files before they are committed.

## Contributing

With Husky set up, your files will be automatically formatted before each commit. However, you can also manually check and format:

**Check formatting:**

```bash
mise run format-check
```

**Format files manually:**

```bash
mise run format
```

## Additional Resources

- [Mise Documentation](https://mise.jdx.dev/)
- [Prettier Documentation](https://prettier.io/)
- [Husky Documentation](https://typicode.github.io/husky/)
- [lint-staged Documentation](https://github.com/okonet/lint-staged)
- [EditorConfig](https://editorconfig.org/)
- [GitHub Copilot](https://github.com/features/copilot)
