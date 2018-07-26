#!/usr/bin/env bash

# Remove sample file from Git Hooks
rm -f $(pwd)/.git/hooks/pre-commit

# Make symlink to pre-commit script
ln -nsf $(pwd)/git-hooks/pre-commit.sh $(pwd)/.git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit