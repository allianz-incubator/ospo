
# Cloning Repositories from the Allianz GitHub Organization

This guide provides two methods: using a fine-grained token manually or using the GitHub CLI.
 Github [recommends](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#keeping-your-personal-access-tokens-secure) using the CLI, 
 as it is more secure and convenient.

---

## Method 1: Using GitHub CLI (Recommended)

### Prerequisites:
- Git installed on your system.
- GitHub CLI (`gh`) installed on your system. [Download](https://cli.github.com/).
- GitHub account for authentication.

### Instructions:

1. **Authenticate GitHub CLI:**
    - Authenticate gh with your GitHub account:
        ```sh
        gh auth login
        ```
    - Follow the prompts to authenticate using your GitHub credentials or a web browser.

2. **List and Clone Public Repositories:**
    - List public repositories of the organization:
        ```sh
        gh repo list allianz
        ```
    - Clone a repository using gh:
        ```sh
        gh repo clone allianz/<repository>
        ```

3. **Additional `gh` Commands:**
    - View details of a repository:
        ```sh
        gh repo view allianz/<repository>
        ```
    - Create an issue in a repository:
        ```sh
        gh issue create --title "Issue title" --body "Issue description" --repo allianz/<repository>
        ```

---

## Method 2: Manual Setup with Fine-Grained Token

### Prerequisites:
- Git installed on your system.
- GitHub account to create tokens.

### Instructions:

1. **Create a Fine-Grained Personal Access Token:**
    - Go to your GitHub account settings.
    - Navigate to Settings > Developer settings > Personal access tokens > Fine-grained tokens.
    - Click on `Generate new token`.
    - Provide a name and set an expiration date for the token.
    - Under *Resource owner*, select Allianz.
    - Select `Only select repositories` and choose the repositories you want to access.
    - Grant the following repository permissions:
        - Contents: `Read and write`
        - Metadata: `Read`
    - Click `Generate token`.
    - Copy and save the token securely.

2. **Clone a Repository:**
    - Clone the desired repository using the token:
        ```sh
        git clone https://github.com/allianz/<repository>.git
        ```
    - When prompted, specify the token as the password.

