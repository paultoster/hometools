import tomllib
INI_FILENAME = "key_file.ini"
def get_keys():
    try:
        with open(INI_FILENAME, "rb") as f:
            key_dict = tomllib.load(f)
    except Exception as e:
        raise Exception(f"tomllib: Bei lesen {INI_FILENAME} gibt Fehler: {e.args[:]}")
    # endtry
    return key_dict
# end def