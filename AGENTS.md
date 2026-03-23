# AGENTS.md

Guide for AI agents working in this dotfiles repository.

## Project Overview

This is a personal dotfiles repository for managing configuration files across different systems (Linux/macOS). It uses symbolic linking to deploy configs from this repo to `~/.config/`.

**Key Components**:
- `config/` - Contains all configuration files that get symlinked to `~/.config/`
- `link.sh` - Symlinks all config files to the home directory
- `fish_theme.sh` - Installs Fish shell theme (bobthefish)
- `hooks/` - Empty directory for potential git hooks

## Essential Commands

### Setup/Installation
```bash
# Create symlinks for all config files
./link.sh

# Install Fish theme (bobthefish from oh-my-fish)
./fish_theme.sh
```

### Git Operations
```bash
# Standard git workflow
git status
git add .
git commit  # Will use gitmoji template
git push    # Auto-setup remote enabled
```

## Directory Structure

```
dotfiles/
├── config/               # All config files to be symlinked
│   ├── git/             # Git configuration
│   │   ├── config       # Git user config and settings
│   │   ├── ignore       # Global gitignore
│   │   └── commit_template.txt  # Gitmoji commit template
│   └── mise/            # Mise version manager config
│       └── conf.d/
│           └── common.toml  # Tool installations
├── hooks/               # (Empty) For git hooks
├── link.sh             # Main setup script
├── fish_theme.sh       # Fish theme installer
└── README.md           # (Minimal) Project readme
```

## Configuration Details

### Git Configuration (`config/git/config`)
- **User**: ikura-hamu with GitHub no-reply email
- **Editor**: VS Code (`code --wait`)
- **Default branch**: `main`
- **Auto-setup remote**: Enabled (auto-configures upstream on first push)
- **Credential helper**: Uses `gh auth git-credential` (GitHub CLI)
- **Commit template**: Uses gitmoji-based template at `~/.config/git/commit_template.txt`

### Global Gitignore (`config/git/ignore`)
Excludes:
- `mise.local.toml` - Local mise configuration
- `.ikura-hamu.txt` - Personal files

### Mise Tools (`config/mise/conf.d/common.toml`)
Installed tools (all latest versions):
- `gemini-cli` - Gemini AI CLI
- `github-cli` - GitHub CLI (`gh`)
- `github:lusingander/serie` - Git series viewer
- `codex` - Code assistant

## Shell Scripts

### Script Conventions
- **Shebang**: `#!/bin/bash`
- **Error handling**: `set -eu -o pipefail` (fail fast on errors)
- **Comments**: Japanese comments acceptable for explanations

### `link.sh` - Configuration Symlinker
**Purpose**: Creates symbolic links from `config/` to `~/.config/`

**How it works**:
1. Finds all files in `config/` directory
2. Calculates relative paths
3. Creates target directories if needed (`mkdir -p`)
4. Creates symlinks using `ln -s -F` (force overwrite)
5. Prints confirmation for each linked file

**Key variables**:
- `SOURCE_DIR` - Points to `$(repo_root)/config`
- `TARGET_DIR` - Points to `$HOME/.config`

### `fish_theme.sh` - Fish Theme Installer
**Purpose**: Downloads and installs bobthefish theme for Fish shell

**How it works**:
1. Fetches latest tarball from `oh-my-fish/theme-bobthefish` via GitHub API
2. Extracts `*/functions/*` files to `~/.config/fish/`
3. Uses `--strip-components=1` to flatten directory structure

**Requirements**:
- `curl` for downloading
- `tar` for extraction
- Fish shell installed

## Cross-Platform Considerations

### Cross-Platform Compatibility
The scripts are designed to work on both macOS (BSD utilities) and Linux (GNU utilities):

**link.sh**:
- Uses `rm -f` before `ln -s` instead of platform-specific `-F` flag
- Checks for existing files/symlinks before creating new ones
- Uses portable `mkdir -p` and `ln -s` commands

**fish_theme.sh**:
- Downloads tarball to temporary directory instead of piping to tar with filters
- Uses `find` and `cp` instead of tar's `--strip-components` with glob patterns
- Avoids platform-specific tar options like `--wildcards` (GNU) vs glob patterns (BSD)

**Key Principles**:
1. Avoid platform-specific flags (e.g., `ln -F` on macOS, `ln --force` on Linux)
2. Use temporary directories for complex file operations
3. Prefer portable commands (`find`, `cp`, `rm`) over advanced tar features
4. Test on both platforms when modifying scripts

## Commit Message Conventions

Uses **gitmoji** prefixes (defined in `config/git/commit_template.txt`):

| Emoji | Shortcode | Meaning |
|-------|-----------|---------|
| ✨ | `:sparkles:` | Introduce new features (prefix: `fe:`) |
| 🐛 | `:bug:` | Fix a bug (prefix: `bu:`) |
| ✅ | `:white_checkmark:` | Add or update test (prefix: `te:`) |
| 🩹 | `:adhesive_bandage:` | Simple fix for non-critical issue (prefix: `ad:`) |
| ♻️ | `:recycle:` | Refactor code (prefix: `re:`) |
| 💥 | `:boom:` | Introduce breaking changes (prefix: `bo:`) |
| ⚡ | `:zap:` | Improve performance (prefix: `zap:`) |
| 🚧 | `:construction:` | Work in progress (prefix: `wip:`) |
| 🎨 | `:art:` | Improve structure/format (prefix: `fo:`) |
| 🔥 | `:fire:` | Remove code or files (prefix: `rm:`) |
| 🔧 | `:wrench:` | Add/update config files (prefix: `co:`) |
| 📝 | `:memo:` | Add/update documentation (prefix: `do:`) |
| ⬆️ | `:arrow_up:` | Upgrade dependencies (prefix: `up:`) |
| 💄 | `:lipstick:` | Add/update UI and style (prefix: `st:`) |
| 🏭 | `:factory:` | Generate code (prefix: `ge:`) |

**Example commits** (from history):
```
:bug: macでもスクリプトが動くよう修正
:bug: スクリプト修正
:sparkles: fishのテーマ
:sparkles: link用のスクリプト
```

Reference: https://gitmoji.dev/

## Common Tasks

### Adding New Configuration Files
1. Add file to appropriate directory under `config/`
2. Run `./link.sh` to create symlink
3. Commit with appropriate gitmoji (likely 🔧 `:wrench:`)

### Modifying Scripts
1. **Read the script first** - understand the full context
2. **Test on both platforms** if changing core functionality
3. **Prefer short flags** over long flags for cross-platform compatibility
4. **Avoid strict error handling** (`set -eu -o pipefail`) if platform-specific behavior varies
5. Update this AGENTS.md if you discover new patterns or gotchas

### Adding New Mise Tools
1. Edit `config/mise/conf.d/common.toml`
2. Add tool in format: `tool-name = "version"` (or `"latest"`)
3. Run `mise install` to install
4. Run `./link.sh` to update symlink

## Important Gotchas

### 1. Platform-Specific Commands
**Don't assume GNU tools**: macOS uses BSD variants with different flags.
- Always test on the target platform(s)
- Use short flags when possible
- Check man pages for both platforms if adding new commands

### 2. Symlink Behavior
The `link.sh` script uses **force mode** (`-F` flag), which:
- Overwrites existing symlinks
- Will fail if target is a regular file (not a symlink)
- Requires manual cleanup if switching from regular files to symlinks

### 3. Relative Paths in Scripts
Scripts use `$(dirname $(realpath $0))` to find repo root:
- Works from any working directory
- Requires `realpath` to be available (it is on both Linux and macOS)

### 4. Empty Directories
The `hooks/` directory exists but is empty. Purpose is unclear but preserved.

### 5. Configuration Changes
After modifying files in `config/`, changes take effect immediately via symlinks:
- No need to re-run `link.sh` for existing files
- Only re-run `link.sh` when adding **new** files

## Testing & Verification

### Manual Testing Checklist
When modifying scripts:
- [ ] Test on Linux (if available)
- [ ] Test on macOS (if available)
- [ ] Verify symlinks created correctly (`ls -la ~/.config/`)
- [ ] Check for broken symlinks (`find ~/.config -xtype l`)
- [ ] Ensure no errors in script output

### File Verification
```bash
# Check symlinks are correct
ls -la ~/.config/git/
ls -la ~/.config/mise/

# Verify symlink targets
readlink ~/.config/git/config

# Find broken symlinks
find ~/.config -xtype l
```

## Development Guidelines

### Making Changes
1. **Always read files before editing** - understand full context
2. **Test thoroughly** - especially for cross-platform scripts
3. **Use gitmoji conventions** for commits
4. **Update AGENTS.md** if you discover new patterns or conventions
5. **Keep it simple** - this is a personal dotfiles repo, not a framework

### What NOT to Do
- Don't add complex abstractions or frameworks
- Don't assume platform-specific tools
- Don't use long-form GNU flags in scripts
- Don't remove `hooks/` directory (even if empty)
- Don't modify files in `~/.config/` directly - edit in repo and let symlinks handle it

### Code Style
- **Bash scripts**: Clear variable names, comments for complex logic
- **Comments**: Japanese acceptable (owner's preference)
- **Error messages**: English preferred for wider compatibility
- **Paths**: Always use absolute or properly resolved relative paths

## Future Considerations

### Potential Improvements
- Add more robust error handling with platform detection
- Create separate scripts for Linux vs macOS if divergence continues
- Add automated testing (shellcheck, bats)
- Document Fish shell configuration when added
- Add uninstall/cleanup script

### Open Questions
- Purpose of `hooks/` directory?
- Why was `set -eu -o pipefail` removed? (macOS tar incompatibility?)
- Should there be a bootstrap script for first-time setup?

## Resources

- **Gitmoji**: https://gitmoji.dev/
- **Mise**: https://mise.jdx.dev/
- **Oh My Fish**: https://github.com/oh-my-fish/oh-my-fish
- **Bobthefish theme**: https://github.com/oh-my-fish/theme-bobthefish

## Owner Information

- **GitHub**: ikura-hamu
- **Email**: 104292023+ikura-hamu@users.noreply.github.com
- **Primary Platform**: Appears to be Linux (based on recent testing)
- **Secondary Platform**: macOS (based on compatibility fixes)
