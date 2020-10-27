#!/usr/bin/python
import commands
branch = commands.getoutput("git symbolic-ref -q HEAD")
branch = branch.split("/")[-1]

print "Cleaning "+branch
print "--------"

print "Checking out origin/dev"
commands.getoutput("git co origin/dev")

print "Updating remote branch"
commands.getoutput("git push fork "+branch+":"+branch+" -f")

print "Removing remote branch"
commands.getoutput("git push fork :"+branch)
print "Removing local branch"
commands.getoutput("git branch -D "+branch)
