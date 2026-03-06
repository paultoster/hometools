

import sys
import os
from hachoir.parser import createParser
from hachoir.metadata import extractMetadata

t=__file__.split(os.sep)
t[0]=t[0]+os.sep
tools_path = os.path.join(*(t[0:len(t)-2]))
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from tools import hfkt_file_path as hfp
from tools import hfkt_str as hstr
from tools import hfkt_def as hdef

def find_and_copy_mp4_with_creation_time(fullfilename,from_path,to_path,counter,addname):
    """

    """
    status = hdef.OKAY
    errtext = ""

    (filepath, filebody, ext) = hfp.get_pfe(fullfilename)

    f = hfp.get_path_leaves(fullfilename, from_path)
    (rest_path_name, _, _) = hfp.get_pfe(f)

    parser = createParser(fullfilename)
    metadata = extractMetadata(parser)

    # metadata = None

    if metadata:
        print(metadata.get("creation_date"))
        dt = metadata.get("creation_date")
        timebody = str(dt.year) + str(dt.month) + str(dt.day) + "_" + str(dt.hour) + str(dt.minute) + str(dt.second)
    else:
        timebody = ""
    # end if

    parser.close()

    # build new filebody
    newfilebody = timebody + addname  + filebody + "_" + f"{counter:03d}"

    # Copy
    if len(to_path):

        target_pathname = hfp.merge_path_leaves(to_path, rest_path_name)

        newfullfilename = hfp.set_pfe(target_pathname,newfilebody,ext)

        status = hfp.copy(fullfilename, newfullfilename, silent=1)

        if status != hdef.OKAY:
            errtext = errtext + "\n" + f"Kann nicht {fullfilename = } in {newfullfilename = } kopieren"

    # rename
    else:
        newfullfilename = hfp.set_pfe(filepath,newfilebody,ext)

        os.rename(fullfilename,newfullfilename)

    # end if
    return  (status,errtext)
# end def
if __name__ == '__main__':

    counter = 1
    addname = "_A34_"

    path_list_copy_dict = {}
    path_list_copy_dict["K:\\media\\bilder\\2025\\Suedamerika\\4_MachuPichu_Filme"] = ""
    path_list_copy_dict["K:\\media\\bilder\\2025\\Suedamerika\\5_BuenosAires_Filme"] = ""
    path_list_copy_dict["K:\\media\\bilder\\2025\\Suedamerika\\6_Iguazu_Argentinien_Filme"] = ""
    path_list_copy_dict["K:\\media\\bilder\\2025\\Suedamerika\\7_Iguazu_Brasilien_Filme"] = ""
    path_list_copy_dict["K:\\media\\bilder\\2025\\Suedamerika\\8_RioDeJaneiro_Filme"] = ""

    for from_path, to_path in path_list_copy_dict.items():

        fullfilenamelist = hfp.find_file_pattern_pathlist("*.mp4", [from_path])

        for fullfilename in fullfilenamelist:

            (status,errtext) = find_and_copy_mp4_with_creation_time(fullfilename, from_path, to_path, counter, addname)

            if status != hdef.OKAY:
                print(errtext)
            # end if

            counter += 1
        # end for
    # end for





















