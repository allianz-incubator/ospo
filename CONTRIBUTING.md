# Contribution Guidelines
We're delighted to have you here and appreciate your interest in contributing to our project. Your contributions play a vital role in our community's growth and success.

## Ways to Contribute
Code Contributions: As a developer, you can contribute to our project by writing code, fixing bugs, or implementing new features. If you have any questions or need guidance, don't hesitate to ask on our collaboration channels.
Documentation Improvements: Clear and comprehensive documentation is essential for the success of any project. If you have a flair for writing, you can help improve our documentation. Whether it's updating existing guides or creating new ones, your contributions will be highly valued.
Spread the Word: You can also contribute by spreading the word about open source at Allianz. Share it on social media, write blog posts, or simply tell your friends and colleagues about it. Your efforts in promoting our project are greatly appreciated.

## Setting Up Your Development Environment
Before you start contributing, ensure that you have the necessary tools installed on your system:

* **yq:** yq is a powerful tool for processing YAML files. You can install it here.
* **repolinter:** repolinter helps maintain consistency across Git repositories. Install it here.
* **gh:** GitHub CLI (gh) streamlines GitHub tasks, crucial for seamless integration. Install and configure it here.

## Getting Started
Our scripts offer several flags to help during development:

--debug: Enable debug mode for detailed information about script execution for troubleshooting purposes.
--dry-run: Simulate script execution without making any changes, useful for previewing potential effects before applying them.
--org: Specify the organization against which you want to run the script. This option is particularly helpful when you need to run the script against a non-production organization.

Example:

```bash
 ./scripts/lint_repos.sh --org my-test-org --debug --dry-run
```