#!/bin/bash

ISSUE_TEXT=$(cat <<'EOF'
Dear Maintainers,

This repository has been identified as stale due to inactivity. To prevent it from being archived, we kindly request action.

**Action Required:**
To maintain this repository, we recommend creating an empty commit to demonstrate ongoing activity. This can be achieved by running the following command:

```bash
git commit --allow-empty -m "Keep repository active"
```

Archival Notice:
If no action is taken within the next 30 days, this repository will be archived.

Request for Unarchival:
In case the repository is archived and there's a legitimate reason to revive it, please contact ospo@allianz.com with your request for unarchiving.

Thank you for your attention and cooperation.

Best regards,
OSPO Team

EOF
)

# Read excluded repositories from the config file
EXCLUDED_REPOSITORIES=$(yq -r '.excluded_repos | .[]' ../config/archival.yaml | sort)

# Calculate the date one year ago
ONE_YEAR_AGO=$(date -d "1 year ago" +%Y-%m-%dT%H:%M:%SZ)

# Parse command line parameters
ORG_NAME=""
DRY_RUN=false
while [ $# -gt 0 ]; do
    case "$1" in
        --org)
            shift
            ORG_NAME=$1
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Check if organization name is provided
if [ -z "$ORG_NAME" ]; then
    echo "Please provide the organization name using --org option."
    exit 1
fi

# Checks if an issue is open and returns the issue number.
issue_number() {
  local repo="$1"
  local issue_title="$2"

  gh issue list -R "$repo" --state open --json number,title |  jq -r ".[] | select(.title == \"$issue_title\") | .number"
}

# Function to fetch the creation date of an issue
get_issue_creation_date() {
  local repo="$1"
  local issue_title="$2"
  local issue_number=$(issue_number "$repo" "$issue_title")

  if [ -n "$issue_number" ]; then
    gh issue view -R "$repo" "$issue_number" --json createdAt --jq '.createdAt'
  fi
}

# Creates a new GitHub issue or skips the creation if one already exists.
create_issue_if_not_exists() {
  local repo="$1"
  local issue_title="$2"
  local issue_body=$(echo -e "$3")

  existing_issue_number=$(issue_number "$repo" "$issue_title")
  if [ -z "$existing_issue_number" ]; then
      if [ "$DRY_RUN" = true ]; then
        DRY_RUN_MESSAGES+="Dry run: Would create an issue for repository '$repo'.\n"
      else
        gh issue create -R "$repo" --title "$issue_title" --body "$issue_body"
      fi
  else
    echo "An open issue already exists in the repository '$repo'. Skipping creation."
  fi
}


# Closes an open GitHub issue with a given title.
close_issue() {
  local repo="$1"
  local issue_title="$2"
  local issue_number=$(issue_number "$repo" "$issue_title")

  if [ -n "$issue_number" ]; then
    gh issue close -R "$repo" "$issue_number"
    echo "Closed the existing issue in the repository '$repo'."
  fi
}


# Fetch repositories for the organization and remove repos to be excluded
repos=$(gh repo list $ORG_NAME --no-archived --json name --jq '.[].name' | sort)
repos_to_process=$(comm -23 <(echo "$repos") <(echo "$EXCLUDED_REPOSITORIES"))

# Check if the repository has not received a commit for more than a year
for repo in ${repos_to_process[@]}; do

    # Get the last commit date for the repository
    last_commit_date=$(gh repo view $ORG_NAME/$repo --json pushedAt --jq '.pushedAt')

    # Check if the repository is stale (no commits in the last year)
    if [[ "$last_commit_date" < "$ONE_YEAR_AGO" ]]; then
        echo "Stale repository: $ORG_NAME/$repo"
        create_issue_if_not_exists "$ORG_NAME/$repo" "Staleness Warning" "$ISSUE_TEXT"
    else
        close_issue "$ORG_NAME/$repo" "Staleness Warning" 
    fi
done

# Check if the stale warning issue is 30 days old and print a message
for repo in ${repos_to_process[@]}; do
    issue_creation_date=$(get_issue_creation_date "$ORG_NAME/$repo" "Staleness Warning")
    if [ -n "$issue_creation_date" ] && [[ "$issue_creation_date" < "$THIRTY_DAYS_AGO" ]]; then
        echo "The Staleness Warning issue for repository $ORG_NAME/$repo is 30 days old."
        echo "Consider taking appropriate actions."
    fi
done