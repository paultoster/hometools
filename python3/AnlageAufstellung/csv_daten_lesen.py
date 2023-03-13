import sys
import pandas as pd

if( "..\\allg" not in sys.path ):
    sys.path.append("..\\allg")


def csv_daten_lesen(filename : str, pattern_list : list) -> dict:


  df = pd.read_csv(filename, sep=';', encoding="cp1252",usecols=["Name 1","Name 2","IBAN/Kontonummer","Betrag","Wertstellungsdatum","Buchungsdatum"])
  #

  # header_liste = df.head() 
  for col in df.columns:
     
    # df2  = df[df[col].str.contains("fidus", regex=True, na=False)]

    liste = df.index[df[col].str.contains("fidus", regex=True, na=False, case=False)].tolist()


    print(col)

    print(len(liste))

    print(df.iloc[liste]) 

    print(df)

    
#enddef


