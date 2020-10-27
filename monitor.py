#!/usr/bin/python
import argparse
import os.path
import sys


def cardspringTest(f):
	for line in f:
		if "SUCCESS - Cardspring integration testing was successful" in line:
			return True
	
	print "Cardspring integration testing FAILED"
	return False


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Process heroku output')
	parser.add_argument("-m", "--mode", action="store", dest="mode", help="Select a type of monitoring to perform")
	parser.add_argument("-f", "--file", action="store", dest="filepath", help="The file to be read in")

	argResults = parser.parse_args()
	
	
	testDict = {
								"cardspring":cardspringTest,
							}

	
	

	if argResults.filepath==None or not os.path.exists(argResults.filepath):
		print argResults.filepath, "not found\n"
		parser.print_help()
		sys.exit(1)

	if argResults.mode not in testDict.keys():
		print argResults.mode, "is not an available mode:", testDict.keys()
		sys.exit(1)
		
	
	f = open(argResults.filepath).readlines()
	
	
	if not testDict[argResults.mode](f):
		for i in f:
			print i
		sys.exit(1)
	else:
		print "Test successful -", argResults.mode
	
	
	


