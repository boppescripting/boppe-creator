# boppe-jobcreator
## Requirements
- `qb-core`
- `qb-input`

## Installation
1. Place the `boppe-creator` folder into your resources folder (one that is ensured).

## Usage
1. Run the `/createjob` or `/creategang` command in-game.
2. Fill out the fields on the first screen, then hit the continue button.
3. Fill out the information for each grade, then hit the complete button.
4. Job/gang created!

## Permissions
If you would like to change the required permission level from `admin` (default), then go into the `server/config.lua` file and alter it on line 2.

## Screenshots
![Create Job Pt.1](https://i.imgur.com/5KqFg55.jpeg)
![Create Job Pt.2](https://i.imgur.com/RsXVeCJ.jpeg)
![Confirmation notification](https://i.imgur.com/9nN06GK.png)
![Proof of job working](https://i.imgur.com/HOPdldg.png)
![Job in config file](https://i.imgur.com/wd3VrVK.png)

## Changelog
### 1.1
- Changed script name from `boppe-jobcreator` to `boppe-creator`.
- Added ability to create gangs.
- Added ability to list which grade is the boss grade (by name).
- Jobs and gangs no longer save in a config file within boppe-creator. They now automatically save to the QBCore shared files to ensure there is no need to update your core object in other scripts (especially escrowed ones).