#!/bin/bash
# Flutter Setup Script for GitHub Copilot Agents
# This script installs Flutter SDK for use in Copilot agent environments
# Don't exit on errors, handle them gracefully
set +e

echo "=========================================="
echo "Setting up Flutter for GitHub Copilot agents..."
echo "=========================================="

# Define Flutter installation directory
FLUTTER_DIR="$HOME/flutter"

# Check if Flutter is already installed
if [ -d "$FLUTTER_DIR" ] && [ -x "$FLUTTER_DIR/bin/flutter" ]; then
    echo "✓ Flutter is already installed at $FLUTTER_DIR"
else
    echo "Installing Flutter SDK..."
    
    # Clone Flutter from GitHub (stable branch)
    cd "$HOME" || { echo "✗ Error: Cannot change to home directory"; exit 1; }
    if git clone https://github.com/flutter/flutter.git -b stable --depth 1; then
        echo "✓ Flutter cloned successfully to $FLUTTER_DIR"
    else
        echo "✗ Error: Failed to clone Flutter repository"
        exit 1
    fi
fi

# Add Flutter to PATH if not already present
if [[ ":$PATH:" != *":$FLUTTER_DIR/bin:"* ]]; then
    export PATH="$FLUTTER_DIR/bin:$PATH"
    echo "✓ Added Flutter to PATH"
fi

# Configure Flutter (disable analytics and enable web support)
echo "Configuring Flutter..."
$FLUTTER_DIR/bin/flutter config --no-analytics 2>/dev/null || true
$FLUTTER_DIR/bin/flutter config --enable-web 2>/dev/null || true

# Verify Flutter installation
echo "Verifying Flutter installation..."
echo "(Note: Initial setup may require downloading Dart SDK...)"
# Limit output to first 20 lines to avoid verbose output while still showing version info
$FLUTTER_DIR/bin/flutter --version 2>&1 | head -20 || echo "Note: Flutter will complete setup on first use"

# Install project dependencies
if [ -f "pubspec.yaml" ]; then
    echo "Installing project dependencies..."
    if $FLUTTER_DIR/bin/flutter pub get; then
        echo "✓ Dependencies installed successfully!"
    else
        echo "⚠ Warning: Failed to install dependencies. You may need to run 'flutter pub get' manually."
    fi
else
    echo "⚠ Warning: pubspec.yaml not found in current directory"
fi

echo ""
echo "=========================================="
echo "Flutter is now ready for Copilot agents!"
echo "Flutter location: $FLUTTER_DIR"
echo "To use Flutter in your shell, add to PATH:"
echo "  export PATH=\"\$HOME/flutter/bin:\$PATH\""
echo "=========================================="
