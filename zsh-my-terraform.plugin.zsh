# Helper function to get the current PR info
_get_gh_pr_info() {
  if command -v gh >/dev/null 2>&1; then
    gh pr view --json number,url 2>/dev/null
  fi
}

# Helper function to get the default Terraform plan filename, given a PR number
_get_tfplan_filename() {
  local pr_number="$1"
  if [[ -n "$pr_number" ]]; then
    echo "pr-${pr_number}.tfplan" # Use PR number in plan file name if available
  else
    echo "plan.tfplan" # Default plan file name if no PR is detected
  fi
}

# Helper function to check if a plan file exists
_check_plan_file_exists() {
  local plan_file="$1"
  if [[ ! -f "$plan_file" ]]; then
    echo "Plan file '$plan_file' does not exist. Run 'tfp' first."
    return 1
  fi
}

# "terraform plan" command with dynamic plan filename
unalias tfp 2>/dev/null
tfp() {
  local pr_info pr_number pr_url plan_file cmd
  pr_info="$(_get_gh_pr_info)"
  if [[ -n "$pr_info" ]]; then
    pr_number=$(echo "$pr_info" | jq -r '.number // empty')
    pr_url=$(echo "$pr_info" | jq -r '.url // empty')
  fi
  plan_file="$(_get_tfplan_filename "$pr_number")"

  # If it exists, display information about the PR
  if [[ -n "$pr_number" ]]; then
    cat <<EOF
GitHub PR detected: #${pr_number}
PR URL: ${pr_url}

Plan file: ${plan_file}
EOF
  else
    cat <<EOF
No GitHub PR detected.
Using default plan file: ${plan_file}
EOF
  fi

  cmd=(terraform plan -out=${plan_file} "$@")
  echo "Running: ${cmd[@]}"
  echo "---"
  "${cmd[@]}"
}

# "terraform show" command with dynamic plan filename
unalias tfsh 2>/dev/null
tfsh() {
  local pr_info pr_number plan_file
  pr_info="$(_get_gh_pr_info)"
  if [[ -n "$pr_info" ]]; then
    pr_number=$(echo "$pr_info" | jq -r '.number // empty')
  fi
  plan_file="$(_get_tfplan_filename "$pr_number")"
  _check_plan_file_exists "$plan_file" || return 1
  terraform show -no-color "${plan_file}"
}

# "terraform apply" command with dynamic plan filename
unalias tfa 2>/dev/null
tfa() {
  local pr_info pr_number plan_file
  pr_info="$(_get_gh_pr_info)"
  if [[ -n "$pr_info" ]]; then
    pr_number=$(echo "$pr_info" | jq -r '.number // empty')
  fi
  plan_file="$(_get_tfplan_filename "$pr_number")"
  _check_plan_file_exists "$plan_file" || return 1
  terraform apply "$plan_file"
}
