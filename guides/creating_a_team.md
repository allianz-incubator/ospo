# Creating a Team

The access to GitHub repositories is entirely facilitated through GIAM. All user access requests are initiated and approved through GIAM. Technically, GitHub teams act only as a thin wrapper around GIAM groups, and are created implicitly on the fly when modifying repository assignments.

Note: A single team can be assigned to multiple repositories, and conversely, one repository can have multiple teams assigned. 

To create a new GitHub team and assign it to one or more repositories, follow these steps:

1. Create a new Azure security group in GIAM ([details](https://allianzms.sharepoint.com/:u:/r/teams/DE1214-6256295/SitePages/Create-Azure-Security-Group.aspx?csf=1&web=1&share=EfrPwMMX75xNsyVxYMxXFLgBapAXQHGFz9OpuVGTnT0YAw&e=QyKoaB)). The group name is flexible, allowing spaces and capitalized letters. This name will also be used to create a GitHub team with the same name. Ensure the name is unique in GIAM, and no Microsoft Teams with an identical name exist.

2. Modify the configuration file [repos.yaml](../config/repos.yaml) to include the desired assignments. You can either submit a pull request with the changes, or if you prefer, create a ticket outlining your desired modifications, and we will handle the pull request on your behalf.

To join the GitHub team, users must belong to two GIAM groups: first, the 'Allianz Open Source' group, and second, the group created in step 1 above. Detailed instructions on joining a team can be found [here](guides/joining_a_team.md).
