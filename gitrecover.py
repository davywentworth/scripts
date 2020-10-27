import commands

x = commands.getoutput("git fsck --full --no-reflogs | grep commit").split("\n")

for (i,r) in enumerate(x):
  print "##############"
  print i
  print "##############"
  rev = r.split()[2]
  out = commands.getoutput("git show "+rev)
  if "1.5x" in out:
    print out
    print "***********"
    print i,"/",len(x), rev
    print "***********"
    print "Hit <enter> to continue"
    raw_input('')
