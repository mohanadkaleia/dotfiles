# .dotfiles 👾

For long time I wanted to sync my dotfiles with my git account. Well, here it is! In this repo, I'm sharing my environment's dotfiles. 

*Note*: This works only on OSX operating systems, I will update it later on to cover Ubuntu systems.

# How it works
This will ask you to bootstrap your OS by installing a bunch of tools (you can see and customize whatever you need by modifying `install.sh` file). You can skip this step if you want. Then the script will backup your dotfiles specified by the `FILES_TO_TRACK` variable in the `main.py` file. Then will link the dot files from this project with your home directory. 

# Prerequisit
Nothing, only `Python` 🐍


```
1. Clone this repo into your local
2. python main.py
3. Enjoy!!
```

# License
Well, rights are lefted here, you can freely fork and use this project. (lol I doubt anyone would do that anyway)