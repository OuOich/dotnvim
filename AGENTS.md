# AGENTS.md

Guidance for coding agents working in this repository.

## Repository scope

- This repo is a Nix flake that builds a Nixvim (Neovim) configuration.
- Primary languages: `Nix` and `Lua`.
- Entry point for flake outputs: `flake.nix`.
- Main module trees: `config/`, `options/`, `lib/`, `lua/`, `overlays/`.

## Environment and setup

- Preferred environment: `nix develop` (provides formatter/lint tools).
- Direct shell entry: `nix develop`.
- One-off command without entering shell: `nix develop -c <cmd>`.
- Available dev tools from `shell.nix`: `nil`, `statix`, `nixfmt`, `stylua`, `prettier`.

## Build commands

- Build default package:
  - `nix build .#default`
- Build platform-specific default package:
  - `nix build .#packages.x86_64-linux.default`
- Show flake outputs:
  - `nix flake show`

## Run commands

- Run Neovim app from flake:
  - `nix run .#nvim`
- Print generated init via app:
  - `nix run .#nixvim-print-init`

## Lint and format commands

- Nix static lint (whole repo):
  - `nix develop -c statix check .`
- Nix static lint (single file):
  - `nix develop -c statix check config/tools/telescope.nix`
- Format Nix files (whole repo):
  - `nix develop -c nixfmt **/*.nix`
- Format check Nix file (single file):
  - `nix develop -c nixfmt --check flake.nix`
- Format Lua files (whole repo):
  - `nix develop -c stylua .`
- Format check Lua file (single file):
  - `nix develop -c stylua --check lua/utils/root.lua`
- Prettier check (repo-level config and supported files):
  - `nix develop -c prettier --check .`
- Prettier fix:
  - `nix develop -c prettier --write .`

## Test/check commands

- Canonical repo validation:
  - `nix flake check`
- All systems validation:
  - `nix flake check --all-systems`
- Current state note: `checks.x86_64-linux` is empty (`{}`), so there are no unit/integration tests yet.

## Single-test equivalent guidance

- There is no test runner with named tests in this repo today.
- Use a single-target build/check as the closest equivalent:
  - Build one output: `nix build .#packages.x86_64-linux.default`
  - Lint one file: `nix develop -c statix check <file>.nix`
  - Format-check one file: `nix develop -c stylua --check <file>.lua`

## File layout conventions

- `config/default.nix` auto-imports all `*.nix` under `config/` except itself.
- `options/default.nix` auto-imports all `*.nix` under `options/` except itself.
- `config/default.nix` also exports Lua files from `lua/` via `extraFiles`.
- Add new feature modules as standalone files in the appropriate subtree; avoid manual import wiring unless pattern changes.

## Nix style guidelines

- Use 2-space indentation.
- Keep line width close to 120 where practical.
- Prefer trailing semicolons and explicit attr sets.
- Use multiline function arg sets in stable order, usually:
  - `{ config, lib, lib', pkgs, ... }:` as needed.
- Keep `let ... in` blocks small and purpose-driven.
- Prefer `lib.mkIf` for conditional configuration instead of ad-hoc branching.
- Prefer `with lib'.utils.wk;`/`with lib'.icons;` only in local scopes where it improves readability.
- When embedding Lua in Nix, use `__raw` and `/* lua */ '' ... ''` blocks.
- Follow existing patterns for plugin definitions under `plugins.<name>`.
- For lists/attrs, keep deterministic ordering when possible (alphabetic or conceptual groups).

## Lua style guidelines

- Use 2 spaces; formatting is governed by `.stylua.toml`.
- Prefer single quotes in Lua where formatter allows.
- Module pattern: `local M = {}` + functions + `return M`.
- Require modules at top-level unless lazy-loading is intentional.
- Use `utils.lazy_require(...)` when deferring expensive/optional modules.
- Keep functions focused and avoid deep nesting.
- Use EmmyLua annotations (`--- @param`, `--- @return`, `--- @class`) for non-trivial APIs.
- Prefer local helpers for repeated logic.

## Imports and dependencies

- Nix:
  - Import local modules with relative paths.
  - Reuse `lib'` helper namespaces instead of duplicating utility logic.
  - In embedded Lua (`__raw`/`extraConfigLua*`), prefer the global `Utils.<module>` (from `config/luaset.nix`) instead of `require('utils.<module>')`.
- Lua:
  - Use `require('utils')` and related utility modules consistently.
  - Avoid hard-coding plugin internals when a utility wrapper exists.

## Naming conventions

- Nix files: kebab-case filenames (e.g., `render-markdown.nix`).
- Lua files: snake_case filenames (e.g., `quick_settings.lua`).
- Lua modules/tables: `M` for module table, descriptive local variable names.
- Nix attrs: lowerCamelCase for option fields where ecosystem expects it.
- Key descriptions (`desc`) should be title case and action-oriented.

## Commit scope conventions

- For changes under `lua/`, prefer commit scopes that match the owning feature/config area, not just `utils`.
- Example: changes in `lua/utils/oil.lua` should use `tools/oil` scope (for example: `refactor(tools/oil): ...`).

## Types and option handling

- In Nix, prefer typed option APIs when defining options (see `options/plugins/im-select.nix` pattern).
- In Lua, guard assumptions about optional values (`nil` checks before use).
- Preserve explicit conversions/normalization paths in root/lsp helpers.

## Error handling and resilience

- Use `pcall(require, ...)` for optional plugin dependencies.
- Fail fast in Nix helper functions with `throw` for invalid inputs (see `lib/utils/which-key.nix`).
- In Lua user-facing flows, report actionable errors via `vim.notify(..., vim.log.levels.ERROR, ...)`.
- Keep fallback behavior explicit (for example: fallback to CWD in root detection).

## Agent workflow recommendations

- Before editing, scan related module trees (`config/`, `lua/`, `lib/`) for existing patterns.
- Prefer minimal, surgical edits that fit current structure.
- When adding new Nixvim config options, query the `nix` MCP first to verify the option path exists and is valid.
- Run targeted checks first (single-file lint/format), then broader checks (`nix flake check`).
- Do not edit `flake.lock` unless dependency updates are intentional.
- Avoid introducing new tooling unless required by the task.

## Lazy-loading guidelines

- Keep lazy-loading infrastructure config in `config/core/lz-n.nix`.
- For new plugins, implement lazy loading by default when it is easy, low-risk, and fits the plugin's usage pattern.
- Do not force lazy loading when implementation is complex, fragile, or offers little startup benefit.
- Pick the trigger type by behavior:
  - `cmd` for command-driven tools (for example git UIs).
  - `ft` for filetype-specific plugins.
  - `event` for deferred startup hooks (for example `DeferredUIEnter`, `LspAttach`, `BufReadPost`).
- Preserve runtime behavior first: keymaps, plugin setup, extensions, and UI customizations must still work after lazy-loading.
- If code may run before a lazy-loaded module is available, guard with `pcall(require, ...)` and explicit fallback behavior.
- Validate every lazy-loading change with:
  - `nix build .#packages.x86_64-linux.default`
  - plugin smoke checks for key workflows (commands/keymaps)
  - startup comparison (`--startuptime`, multi-run) before/after when performance is the goal.

## Quick pre-PR checklist

- `nix develop -c statix check .`
- `nix develop -c stylua --check .`
- `nix develop -c prettier --check .`
- `nix flake check`
- Smoke run if behavior changed: `nix run .#nvim`
