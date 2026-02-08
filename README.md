# Spacefin-cli
This is collection with full themes (both layout and Cosmic theme), development enviroments and aliases and python script for setting them for [Spacefin](https://github.com/ExistingPerson08/Spacefin). 

You can add your own themes, enviroments or aliases, just make pull request ;).

PKG build is mainly made for Spacefin, it has not dependencies included. Build it on your own.

## Running script on other distros

Script is made for Spacefin but it should work on any distro. Script requires Python 3.8 or newer.
Note that most run aliases won't work on other distros. If you want script to use your repo, just change this lines:

```python
# Config
DEFAULT_REPO_URL = "https://github.com/ExistingPerson08/Spacefin-cli.git"
REPO_FOLDER_NAME = "spacefin-assets"
HOME_DIR = os.path.expanduser("~")
```
