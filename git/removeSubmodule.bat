@rem This is a simple batch script to remove a submodule reference from a 
@rem working directory
@rem Call the script by
@rem 1) cd path\to\your\workspace
@rem 2) path\to\removeSubmodule.bat submoduleName

@rem See https://stackoverflow.com/questions/1260748/how-do-i-remove-a-git-submodule for more details

@echo Removing submodule %1
git submodule deinit %1
git rm %1
git rm --cached %1
rm -rf .git/modules/%1
