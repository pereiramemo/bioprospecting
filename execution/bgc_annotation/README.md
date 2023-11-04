# New Atlantis Labs Notebook Templates
This repo contains templates for creating public facing notebooks showcasing your tools on the NA cloud lab.

To download and copy the contents of this repo, make an empty directory and cd into it. 
Then run the following to download the contents of this repositiory:

    git clone https://github.com/new-atlantis-labs/nal-notebook-templates

    git remote remove origin 

The second command detaches your fork from the template repo. You man also want to make the repo no longer a git repo.
To do that and potentially merge this folder into a new repo or make a new git repo run the following:

    rm -rf .git

Ensure this command is run in your template directory and not in a main directory.
Do whatever changes you want to develop the notebooks for your protocol/tool.
To upload this to github, make a new repo on the site and then run the following in your command line.
To add to an existing repo, just drag and drop the folder of your notebooks into the already prepared git repo.

    git init
    git remote add origin <https://github.com/<username>/<repo-name>
    git add . 
    git commit -m "message"
    git push 
  
Instructions on making PAT for this upcoming: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

Or use github desktop.

  
