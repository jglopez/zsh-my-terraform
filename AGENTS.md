# zsh-my-terraform

Custom oh-my-zsh plugin that overrides stock `terraform` plugin aliases with PR-aware functions.

## Functions

All three auto-detect the current PR number via `gh pr view` and name the plan file `pr-<number>.tfplan` (falls back to `plan.tfplan` when no PR is detected).

- `tfp` — `terraform plan -out=pr-<number>.tfplan`. Passes through extra args (e.g. `-target`).
- `tfsh` — `terraform show -no-color pr-<number>.tfplan`. Useful for copying plan output into PRs.
- `tfa` — `terraform apply pr-<number>.tfplan`. Errors if the plan file doesn't exist.

## Workflow

`tfp` → `tfsh` (copy output for PR) → `tfa`

Jeremy runs these himself in his terminal. Don't run them on his behalf unless explicitly asked.
