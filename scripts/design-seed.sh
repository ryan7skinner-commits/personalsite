#!/usr/bin/env bash
# Prints a random seed for design exploration (see .claude/skills/site-design).
# Models can't pick at random, so creative directions are derived from this
# string instead of from "be unique". Never put the seed itself on the site.
set -euo pipefail
LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64
echo
