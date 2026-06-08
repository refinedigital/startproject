From VS Code, how do begin a new project the smart way. Assume we have created a {projectname}.code-workspace and we're in the project root directory with VS Code (ZSH) Terminal Open.



Begin project:

- Add current folder to VS Code Project Settings

- Init git

- Add correct SSH config to git

- Create README.md and .gitignore files with default content for MacOS

- git branch -M main

- git add .

- git commit -m "{app | feature | other}: {Initial commit comment}"

Ex. git commit -m "app: CodeReview App for VS Code"

- git remote add origin git@github.com-{project_owner}:{repo_owner}/{repo_name}.git

Ex. git remote add origin git@github.com-refinedigital:refinedigital/codereview.git

- git push -u origin main