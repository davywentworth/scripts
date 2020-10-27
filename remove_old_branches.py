import commands

f = open("/Users/davy/dev/python/old_branches.tmp")
old_files = f.readlines()
f.close()

for i in old_files:
  print commands.getoutput("git branch -D " +i.strip("\n"))
