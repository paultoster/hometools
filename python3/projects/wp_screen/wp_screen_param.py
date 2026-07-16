
class Param:
    INI_DICT_PROOF_LISTE = [("store_path", "str"),
                            ("katalog_liste_file_name", "str", "str", "katalog_liste"),
                            ("wp_func_ini_file_name","str"),
                            ("katalog_isin_liste_pre_file_name", "str", "str", "katalog_isin_liste_"),
                            ("sigset_liste_file_name", "str", "str", "sigset_liste"),
                            ("sigset_dict_pre_file_name", "str", "str", "sigset_dict_"),
                            ("tab_liste_file_name", "str", "str", "tab_liste"),
                            ("tab_dict_pre_file_name", "str", "str", "tab_dict_"),
                            ("scre_liste_file_name", "str", "str", "scre_liste"),
                            ("scre_dict_pre_file_name", "str", "str", "scre_dict_"),
                            ("scre_dataclass_pre_file_name", "str", "str", "scre_dataclass_")
                            ]

    LOG_SCREEN_OUT = 1

    SIG_NULL    = "0"
    SIG_COMMENT = "#"
    SIG_KURS    = "kurs"
    SIG_CLOSE   = "close"
    SIG_OPEN    = "open"
    SIG_HIGH    = "high"
    SIG_LOW     = "low"
    SIG_VOLUME  = "volume"
    SIG_2PAR_NP_OBJ  = "np_obj"
    SIG_2PAR_LINGRAD = "lingrad"
    SIG_2PAR_SMA = "sma"
    SIG_2PAR_EMA = "ema"
    SIG_3PAR_VERGLEICH = "vergleich"

    SIG_TYPE_NULL    = 0
    SIG_TYPE_COMMENT = 1
    SIG_TYPE_KURS    = 2
    SIG_TYPE_CLOSE   = 3
    SIG_TYPE_OPEN    = 4
    SIG_TYPE_HIGH    = 5
    SIG_TYPE_LOW     = 6
    SIG_TYPE_VOLUME  = 7
    SIG_TYPE_2PAR_NP_OBJ  = 8
    SIG_TYPE_2PAR_LINGRAD = 9
    SIG_TYPE_2PAR_SMA = 10
    SIG_TYPE_2PAR_EMA = 11
    SIG_TYPE_3PAR_VERGLEICH = 12

    SIG_STORE_DATUM = "datum_array"
    SIG_STORE_GRAD  = "grad"

    TAB_SPEZ_GT = ">"
    TAB_SPEZ_LT = "<"
    TAB_SPEZ_GE = ">="
    TAB_SPEZ_LE = ">="
    TAB_SPEZ_EQ = "=="

    TAB_SEC_BI = "bi"  # basict info
    TAB_SEC_SIG = "sig" # signal von sigset
    TAB_FMT_STR = "str"
    TAB_FMT_INT = "int"
    TAB_FMT_FLOAT = "float"
    TAB_FMT_SPEZ = "spez"
    TAB_FMT_FLOAT_SEP = "."
    TAB_FMT_SPEZ_BRACKET_OPEN = "["
    TAB_FMT_SPEZ_BRACKET_CLOSE = "]"
    TAB_FMT_SPEZ_SEP = ";"
    TAB_FMT_SPEZ_COMMAND_SEP = ":"

    TAB_COLOR_WHITE = "white"
    TAB_COLOR_BLACK = "black"
    TAB_COLOR_RED = "red"
    TAB_COLOR_GREEN = "green"
    TAB_COLOR_YELLOW = "yellow"
    TAB_COLOR_BLUE = "blue"
    TAB_COLOR_MAGENTA = "magenta"
    TAB_COLOR_CYAN = "cyan"
    TAB_COLOR_GRAY = "gray"

    TAB_COLOR_LISTE = [TAB_COLOR_WHITE,
                       TAB_COLOR_BLACK,
                       TAB_COLOR_RED,
                       TAB_COLOR_GREEN,
                       TAB_COLOR_YELLOW,
                       TAB_COLOR_BLUE,
                       TAB_COLOR_MAGENTA,
                       TAB_COLOR_CYAN,
                       TAB_COLOR_GRAY]

    TAB_COLOR_SPEZ = "spez"
    TAB_COLOR_SPEZ_BRACKET_OPEN = "["
    TAB_COLOR_SPEZ_BRACKET_CLOSE = "]"
    TAB_COLOR_SPEZ_SEP = ";"
    TAB_COLOR_SPEZ_COMMAND_SEP = ":"

    SCRE_KATALOG = "katalog"
    SCRE_SIGSET  = "sigset"
    SCRE_TAB     = "tab"





#end def