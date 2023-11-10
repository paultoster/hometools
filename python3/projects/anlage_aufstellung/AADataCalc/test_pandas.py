import sys

tools_path = "D:\\tools\\tools_tb\\python3"

if( tools_path not in sys.path ):
  sys.path.append(tools_path)

import pandas as pd
from difflib import get_close_matches

cell_liste = ['Name 2','Name 1']

df = pd.read_csv("Export_317413609.csv",sep = ';')

a = df.loc[0,:].tolist()

print(a)

c = df.columns.tolist()
print(c)


print(get_close_matches('Name1',c,n=1))