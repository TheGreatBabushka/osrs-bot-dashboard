# GitHub Copilot Agent Configuration

This directory contains configuration files for GitHub Copilot agents working on this repository.

## Files

### `copilot-setup.sh`

This script automatically installs and configures Flutter for Copilot agents. It:

1. **Clones Flutter SDK** from the official GitHub repository (stable branch)
2. **Configures Flutter** with recommended settings (no analytics, web support enabled)
3. **Adds Flutter to PATH** for use in subsequent commands
4. **Verifies installation** and provides status information

### Usage

The script is automatically executed by Copilot agents when they start working on this repository. It can also be run manually:

```bash
./.github/copilot-setup.sh
```

After running the setup script, Flutter commands will be available:

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter --version
flutter pub get
flutter analyze
flutter test
```

### What Gets Installed

- **Flutter SDK**: Latest stable version from GitHub
- **Location**: `$HOME/flutter`
- **Configuration**: Analytics disabled, web support enabled

### Requirements

- **Git**: For cloning the Flutter repository
- **Internet access**: To download Flutter and Dart SDK
- **Disk space**: ~500MB for Flutter SDK

### Troubleshooting

If you encounter issues:

1. **Check Flutter installation**:
   ```bash
   flutter doctor -v
   ```

2. **Verify PATH**:
   ```bash
   which flutter
   # Should output: /home/runner/flutter/bin/flutter (or similar)
   ```

3. **Re-run setup**:
   ```bash
   rm -rf $HOME/flutter
   ./.github/copilot-setup.sh
   ```

### Additional Documentation

- **Project Guidelines**: See [copilot-instructions.md](copilot-instructions.md) for coding conventions and project structure
- **Flutter Documentation**: https://docs.flutter.dev/
