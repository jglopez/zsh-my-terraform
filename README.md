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

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)
   ```sh
   git clone https://github.com/jglopez/zsh-my-terraform ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-my-terraform
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

1. Create a draft GitHub PR.

   - You can use `gh pr create --draft` to create a draft PR from the command line.
   - If you don't have `gh` installed, you can create a PR manually on GitHub.
   - If you don't have a PR, the plugin will default to using `plan.tfplan` as the plan file name.

2. Make changes to your Terraform code.

3. `tfp`: Create a Terraform plan file with a name based on the current PR (if any).

4. `tfsh`: Show the plan you just created. This allows easy copying of the plan output to the clipboard.

   You can use `tfsh | tee >(pbcopy)` (or similar) to copy the plan to your clipboard.

5. Mark the PR as ready for review.

6. `tfa`: Apply the plan file.

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
