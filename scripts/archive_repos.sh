#!/bin/bash
cd "$(dirname "$0")"

ISSUE_TITLE="Inactive Repository Reminder"
ISSUE_TEXT=$(cat <<'EOF'
Dear Maintainers,

This repository has been identified as stale due to inactivity for a long time. If no action is taken within the next 30 days, this repository will be archived.

**Action Required:**
We recommend creating an empty commit to demonstrate ongoing activity. This can be achieved by running the following command:

```bash
git commit --allow-empty -m "Keep repository active"
```

**Request for Unarchival:**
In case the repository is archived and there's a legitimate reason to revive it, please contact ospo@allianz.com with your request for unarchiving.

Thank you for your attention and cooperation.

Best regards,

OSPO Team

EOF
)

# Read excluded repositories from the config file
EXCLUDED_REPOSITORIES=$(yq -r '.excluded_repos | .[]' ../config/archival.yaml | sort)

# Calculate the dates until archiving
STALE_PERIOD=$(date -d "2 year ago" +%Y-%m-%dT%H:%M:%SZ)
GRACE_PERIOD=$(date -d "40 days ago" +%Y-%m-%dT%H:%M:%SZ)

#STALE_PERIOD=$(date -d "1 day ago" +%Y-%m-%dT%H:%M:%SZ)
#GRACE_PERIOD=$(date -d "3 hours ago" +%Y-%m-%dT%H:%M:%SZ)

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
    echo "A '$issue_title' issue already exists in the repository '$repo'. Skipping creation."
  fi
}


# Closes an open GitHub issue with a given title.
close_issue() {
  local repo="$1"
  local issue_title="$2"
  local issue_number=$(issue_number "$repo" "$issue_title")

  if [ -n "$issue_number" ]; then
    if [ "$DRY_RUN" = true ]; then
      DRY_RUN_MESSAGES+="Dry run: Would close the existing issue in the repository '$repo'."
    else
      gh issue close -R "$repo" "$issue_number"
      echo "Closed the existing issue in the repository '$repo'."
    fi
  fi
}


# Archive a repository
archive_repo() {
  local repo="$1"
  
  if [ "$DRY_RUN" = true ]; then
    DRY_RUN_MESSAGES+="Dry run: Would archive repository '$repo'."
  else
    gh repo archive "$repo" -y
    echo "Archived the repository '$repo'."
  fi
}


# Calculate the list of repositories to be processed
repos=$(gh repo list $ORG_NAME --no-archived --json name --jq '.[].name' | sort)
repos_to_process=$(comm -23 <(echo "$repos") <(echo "$EXCLUDED_REPOSITORIES"))

# Iterate over all repositories and create staleness warnings, if needed
echo "Checking..."
for repo in ${repos_to_process[@]}; do

    # Get the last commit date for the repository
    last_commit_date=$(gh repo view $ORG_NAME/$repo --json pushedAt --jq '.pushedAt')

    # Check if the repository is stale (no commits in the last year)
    if [[ "$last_commit_date" < "$STALE_PERIOD" ]]; then
        echo "$ORG_NAME/$repo is stale."
        create_issue_if_not_exists "$ORG_NAME/$repo" "$ISSUE_TITLE" "$ISSUE_TEXT"
    else
        close_issue "$ORG_NAME/$repo" "$ISSUE_TITLE" 
    fi
done

# Iterate over all repositories and archive, if needed
echo
echo "Archiving..."
for repo in ${repos_to_process[@]}; do
    
    # Check if stale warning issue exists for repository
    existing_issue_number=$(issue_number "$ORG_NAME/$repo" "$ISSUE_TITLE")
    if [ -n "$existing_issue_number" ]; then
        
        # Check if grace period is passed
        issue_creation_date=$(gh issue view -R "$ORG_NAME/$repo" $existing_issue_number --json createdAt --jq '.createdAt')
        if [[ "$issue_creation_date" < "$GRACE_PERIOD" ]]; then
            archive_repo "$ORG_NAME/$repo"
        else
            echo "Users still have time to react on on warning issue for $ORG_NAME/$repo. Skipping repository archiving."
        fi
    fi
done


# Print dry run results
if [ "$DRY_RUN" = true ]; then
    echo -e "\nFindings:\n$DRY_RUN_MESSAGES" 
fi
