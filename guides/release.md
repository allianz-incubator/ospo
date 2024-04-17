# Releasing an Open Source Project 🛳️

The following steps must be taken to release a new open source project:

1. **Register your release**. Complete the [registration form](https://forms.office.com/e/6CWzqV1FYe) (internal) to express your intent to release non-product code (such as utility libraries, tools, and sample code).
2. **Get approval**. Obtain business line approval.

3. **Name your project**. 
   - Check that it does not conflict with an existing project or infringe on any [trademarks](https://www.trademarkia.com/). 
   - Don’t use a Allianz brand name.
   - Avoid using a third-party brand name. In certain cases you can use them as descriptors. For example, you can use “Test Libraries for Java” but don’t call something “Java Test Libraries.”
   - Don’t use unclear names. e.g. “Foundation Server”

4. **Remove sensitive assets**.
     - Remove any trademarks or product icons.
     - Remove all internal dependencies or references in your code and documentation. This includes any references to server names, binaries, databases, or email addresses. 
     - Remove comments or documentation references to JIRA links, internal code names, and anything else that wouldn’t make sense to external developers.
     - Remove embarrassing content (curse words, poor coding practices).
     - Remove all embedded credentials, passwords, or other secrets that may be mistakenly added to the code or a configuration file. (Note: we expect secrets to be managed outside of source code, but we ask you to check nonetheless.)
     - Drop the revision history.
     - Conduct a static code analysis for vulnerabilities.

4. **Prepare code for release**.

     - Use consistent code conventions, clear function/method/variable names, and a sensible public API.
     - Keep clear comments, document intentions and edge cases.
     - Ensure the distribution mechanism is as convenient, standard, and low-overhead as possible (RubyGems, Homebrew, Bower, Maven, NuGet, etc.)
     - Enable GitHub Actions for continuous integration.
     - Use inclusive language.

5. **Code license**. 
     - Pick on of the prefered licenses - other licenses must be cleared with legal.
     - Review all license dependencies for compatibility with the chosen license.
     - If your repository vendors third-party OSS which is not managed/vendored by a dependency manager (e.g. `RubyGems`), describe its use and its license 
in a `NOTICE` file. 
     - Add copyright and license headers  at the top of each file (optional):

     ```javascript
     // SPDX-FileCopyrightText: Allianz and others
     // SPDX-License-Identifier: MIT
     ```
6. **Publish the code**. 
     - Create a GitHub team to manage access to the repository. Details can be found [here](creating_a_team.md).
     - Modify the configuration file [repos.yaml](../config/repos.yaml) to include the new project. You can either submit a pull request with the changes, or if you prefer, create a ticket outlining your desired modifications, and we will handle the pull request on your behalf.
7. **Going forward**.
   - Ensure at least one team member is committed to managing community interactions merging pull requests, giving feedback, releasing new versions.
   - Make your life easier as an open source maintainer, [from documenting processes to leveraging your community](https://opensource.guide/best-practices/).
   - [Build a community that encourages people](https://opensource.guide/building-community/) to use, contribute to, and share your project.


----

This release process is based on the GitHub [release process template](https://github.com/github/github-ospo/blob/main/policies/releasing.md) with some adoptions from the [Yahoo release process](https://yahoo.github.io/oss-guide/docs/publishing/prepare.html). The original text is licensed under CC-BY.
