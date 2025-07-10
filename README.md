# zsh-my-terraform Oh My Zsh Plugin

This plugin is designed to
[partially override](https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#partially-overriding-an-existing-plugin)
and extend the official [`terraform`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform) Oh My
Zsh plugin, providing convenient Terraform workflow helpers for use with GitHub pull requests. It
automatically manages plan file names and displays PR context when running Terraform commands.

### Features

- **Dynamic Terraform plan file naming**: If a GitHub PR is detected in the current directory, plan files are
  named `pr-<PR_NUMBER>.tfplan`; otherwise, `plan.tfplan` is used.
- **PR context display**: When running `tfp`, the plugin displays the PR number and URL if available.
- **Single GitHub CLI call**: Fetches PR number and URL in a single call for efficiency.

### Notes

- The plugin is designed to be used in a directory that is part of a GitHub repository with an open PR.
- If no PR is detected, the default `plan.tfplan` is used.
- The plugin is safe to use even if `gh` is not installed; it will fall back to default behavior.

## Requirements

- [Terraform](https://www.terraform.io/)
- [GitHub CLI (`gh`)](https://cli.github.com/)
- [`jq`](https://jqlang.org/) (for parsing PR info)
- Your shell must be in a directory with an open GitHub PR for PR context to be detected.

## Installation

1. Copy `zsh-my-terraform.plugin.zsh` to your Oh My Zsh custom plugins directory, e.g.:
   ```sh
   cp zsh-my-terraform.plugin.zsh ~/.oh-my-zsh/custom/plugins/zsh-my-terraform/
   ```
2. Add `zsh-my-terraform` to the `plugins=(...)` list in your `.zshrc`, making sure it comes after
   `terraform`:
   ```sh
   plugins=(... terraform zsh-my-terraform)
   ```
3. Reload your shell:
   ```sh
   omz reload
   ```

## Usage

- `tfp`: Create a Terraform plan file with a name based on the current PR (if any).
- `tfsh`: Show the plan file for the current PR (or the default plan file). This allows easy copying of the
  plan output to the clipboard.
- `tfa`: Apply the plan file for the current PR (or the default plan file).

## Example

```sh
$ tfp
GitHub PR detected: #123
PR URL: https://github.com/example-org/example-repo/pull/123

Plan file: pr-123.tfplan
Running: terraform plan -out=pr-123.tfplan
---
...terraform output...
```
