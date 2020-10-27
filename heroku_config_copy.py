#!/usr/bin/python
import commands
import argparse

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Copy heroku config from source to destination')
  parser.add_argument("-s", "--source", action="store", dest="source", help="Source heroku app")
  parser.add_argument("-d", "--destination", action="store", dest="destination", help="Destination heroku app")
  parser.add_argument("-c", "--copy-env", action="store", dest="copyEnv", help="Copy the Rack/Rails env vars")

  argResults = parser.parse_args()
  configVars = []
  ignored = []
  for line in commands.getoutput("heroku config -a "+argResults.source).split("\n"):
    if line[0] == "=":
      continue

    splits = line.replace(" ", "").split(":", 1)
    if (argResults.copyEnv == None and (splits[0] == "RACK_ENV" or splits[0] == "RAILS_ENV")):
      continue

    if ":" in splits[1] or "=" in splits[1]:
      splits[1] = "\""+splits[1]+"\""

    configLine = "=".join(splits)

    print configLine
    input =  raw_input("include in copy? (y/n): ")
    if input == "y":
      configVars.append("=".join(splits))
    else
      ignored.append("=".join(splits))


  print " ".join(configVars)
  print "\n\nIgnored\n"
  print "\n".join(ignored)
  if argResults.copyEnv:
    print commands.getoutput("heroku config:set "+" ".join(configVars) + " -a "+argResults.destination)
