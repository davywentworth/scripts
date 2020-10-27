#!/usr/bin/python
import commands

current_project = commands.getoutput("basename `git rev-parse --show-toplevel`").replace('core', 'web')
branch = commands.getoutput("git symbolic-ref -q HEAD")
branch = branch.split("/")[-1]

print "Pushing "+branch+" to fork..."

print commands.getoutput("git push fork "+branch+":"+branch +" -f; open https://github.com/davywentworth/"+current_project+"/compare/thanx:dev...davywentworth:"+branch)
