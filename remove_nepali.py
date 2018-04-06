#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
fout=open(sys.argv[3], 'w')

list=[]
with open((sys.argv[1]),'r') as f:
 for line in f:
  for w in line.decode('utf-8').split():
   word1=w.encode('utf-8')
   list.append(word1)

with open((sys.argv[2]), 'r') as f:
 for line in f:
  if not any(word in list for word in line.split()):
   #print(line)
   fout.write(line)




#for word in line.split():
  # if word in list:
  #  line = line.replace(word, "")
  #fout.write(line)
