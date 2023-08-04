#!/usr/bin/python3
import subprocess

current_project = subprocess.getoutput(
    "basename `git rev-parse --show-toplevel`").replace('core', 'web')
branch = subprocess.getoutput("git symbolic-ref -q HEAD")
branch = branch.split("/")[-1]
long_branch = "davywentworth-"+branch

print("Pushing "+branch+" to MASTER...")
try:
    # make sure we are up to date
    print('fetching...')
    (status, output) = subprocess.getstatusoutput("git fetch origin")
    if (status > 0):
        raise

    print('rebasing onto master...')
    (status, output) = subprocess.getstatusoutput("git rebase origin/master")
    if (status > 0):
        raise

    print('pushing rebase up to fork...')
    (status, output) = subprocess.getstatusoutput("~/dev/python/push.py --skip")
    if (status > 0):
        raise

    print('checking out '+long_branch)
    (status, output) = subprocess.getstatusoutput(
        "git checkout -b "+long_branch+" origin/master")
    if (status > 0):
        raise

    print('pulling from fork...')
    (status, output) = subprocess.getstatusoutput("git pull fork " + branch)
    if (status > 0):
        raise

    print('checking out master...')
    (status, output) = subprocess.getstatusoutput("git checkout master")
    if (status > 0):
        raise

    print('resetting master...')
    (status, output) = subprocess.getstatusoutput(
        "git reset --hard origin/master")
    if (status > 0):
        raise

    print('merging...')
    (status, output) = subprocess.getstatusoutput(
        "git merge "+long_branch)
    if (status > 0):
        raise

    print('pushing to master...')
    (status, output) = subprocess.getstatusoutput("git push origin master")
    quit()

except:
    print(output)
finally:
    print('switching back to '+branch)
    print(subprocess.getoutput("git branch -D "+long_branch))
    subprocess.getstatusoutput("git checkout "+branch)
