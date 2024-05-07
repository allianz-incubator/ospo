# Contribution Guidelines
We're delighted to have you here and appreciate your interest in contributing to our project. Your contributions play a vital role in our community's growth and success.

## Ways to Contribute

**Code Contributions:** As a developer, you can contribute to our project by writing code, fixing bugs, or implementing new features. If you have any questions or need guidance, don't hesitate to ask on our collaboration channels.


**Documentation Improvements:** Clear and comprehensive documentation is essential for the success of any project. If you have a flair for writing, you can help improve our documentation. 

<!--
**Spread the Word:** You can also contribute by spreading the word about open source at Allianz. Share it on social media, write blog posts, or simply tell your friends and colleagues about it. Your efforts in promoting our project are greatly appreciated.-->

## Setting Up Your Development Environment
The following tools are required by our scripts:

* [yq](https://github.com/mikefarah/yq)
* [gh](https://cli.github.com/)
* [repolinter](https://github.com/todogroup/repolinter)

## Getting Started

The main scripts and associated files are:

| Script           | Config        | Workflow          | Description                          |
|------------------|---------------|-------------------|--------------------------------------|
| create_repos.sh  | repos.yaml    | create_repos.yml  | Create repositories and assign teams |
| lint_repos.sh    | policies.yaml | repo_lint.yml     | Enforce minimum standards            |
| archive_repos.sh | archival.yaml | archive_repos.yml | Archive stale projects               |


Example:

```bash
 ./scripts/lint_repos.sh --org my-test-org --debug --dry-run
```