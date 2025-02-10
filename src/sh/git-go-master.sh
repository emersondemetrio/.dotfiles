clear

if [ $(git rev-parse --verify master 2>/dev/null) ]; then
    git checkout master
else
    printf "\n'master' branch not found. Checking out 'main'.\n\n"
    git checkout main
fi

git pull
git status
