import pandas as pd

def read_csv_data(dateirumpfname,datenamecol,strtonumcolnamelist):

    df = pd.read_csv(dateirumpfname + ".csv",
                     sep=";",
                     encoding="utf-8",
                     parse_dates=[datenamecol])
    # alternativ: encoding="latin1" decimal=",",
    
    df = df.sort_values(by=datenamecol, ascending=True)
    
    for name in strtonumcolnamelist:
        #df[name] = pd.to_numeric(df[name],errors="coerce")
        df[name] = (df[name]
                      .str.replace(".", "", regex=False)
                      .str.replace(",", ".", regex=False)
                      .astype(float)
                   )
    # Wochentag
    # df["Wochentag"] = df[datenamecol].dt.day_name(locale="de_DE")
    df["Wochentag"] = df[datenamecol].dt.strftime("%a")
    
    return df
# end def
def datencheck(df):
    print("Columns:", list(df.columns))
    print("Shape:", df.shape)
    print("\nDatentypen:\n", df.dtypes)
    print("\nFehlende Werte:\n", df.isna().sum())
    print("\nDuplikate:", df.duplicated().sum())
    print("\nStatistik:\n", df.describe(include="all"))
# end def
def write_pandas(df,dateirumpfname):
    df.to_parquet(dateirumpfname + ".parquet")
# end def
def read_pandas(dateirumpfname):
    df = pd.read_parquet(dateirumpfname + ".parquet")
    return df
# end def
def merge_data(df1,df2,datenamecol):
    df = pd.concat([df1, df2], ignore_index=True)

    df.drop_duplicates(subset=[datenamecol], inplace=True)
    df.sort_values(by=datenamecol, ascending=True, inplace=True)
    df.reset_index(drop=True, inplace=True)
    
    return df
# end def
df = read_csv_data("wkn_A0YEDG_historic",
                   "Datum",
                   ["Erster","Hoch","Tief","Schlusskurs","Stuecke","Volumen"])

write_pandas(df,"wkn_A0YEDG_historic")
df2 = read_pandas("wkn_A0YEDG_historic")

dfneu = read_csv_data("wkn_A0YEDG_historic_neuer",
                   "Datum",
                   ["Erster","Hoch","Tief","Schlusskurs","Stuecke","Volumen"])

df = merge_data(df2, dfneu,"Datum")

datencheck(df)
print(df)

erstes_datum = df["Datum"].dt.strftime("%d.%m.%Y").iloc[0]
letztes_datum = df["Datum"].dt.strftime("%d.%m.%Y").iloc[-1]
erstes_tag = df["Wochentag"].iloc[0]
letztes_tag = df["Wochentag"].iloc[-1]



print(f"Erstes Datum: {erstes_datum} Tag: {erstes_tag}")
print(f"Letztes Datum: {letztes_datum} Tag: {letztes_tag}")

