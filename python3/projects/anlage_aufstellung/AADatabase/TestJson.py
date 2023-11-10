



import json

dd = {}
d  = {}
d["name1"] = "blabla"
d["name2"] = ["bla1","bla2","bla3","bla4","bla5"]
d["name3"] = 10.3

dd["kont1"] = d

d  = {}
d["name1"] = "abc"
d["name2"] = ["a1","a2","a3"]
d["name3"] = 16

dd["kont2"] = d

with open('testjson.json','w') as file:
  json.dump(dd,fp=file,indent=2)

with open('testjson.json','r') as file:
  newd = json.load(file)

  print(newd)

