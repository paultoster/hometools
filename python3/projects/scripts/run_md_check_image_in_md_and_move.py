import sys
import os
import copy

t=__file__.split(os.sep)
t[0]=t[0]+os.sep
t[len(t)-2] = "tools"
TOOLS_PATH = os.path.join(*(t[0:len(t)-1]))

if( TOOLS_PATH not in sys.path ):
    sys.path.append(TOOLS_PATH)

import hfkt_file_path as hfp
import hfkt_str as hstr
import hfkt_io as hio
import hfkt_def  as hdef
import hfkt_log as hlog


LIST_OF_EXTENSION = ["png","jpg","jpeg","webp"]
BILDER_PATH_NAME  = "_bilder"
def run_md_check_image_in_md_and_move(md_base_path):
    '''

    '''

    log = hlog.log("logfilename.txt")

    liste = hfp.find_file_pattern('*.md', md_base_path)
    for i,item in enumerate(liste):
        # print(f"Nr.: {i+1} {item}")

        if i == 0:
            x = 0
        # end if

        fullfilename = hfp.build_path_with_forward_slash(item)

        (fpath, fbody, fext) = hfp.get_pfe(fullfilename)

        if fbody == "Lichtschalter":
            print("halt")
        # end if

        (okay, lines) = hio.read_ascii_build_list_of_lines(file_name=fullfilename)

        if okay == hdef.OKAY:
            # [[imagefilename,iline,i0,i1]]
            list_of_images_pos,list_iline = get_imagefiles_from_md(lines)
            lines_changed = False
            for i,list in enumerate(list_of_images_pos):

                (modflag,line_mod,ddict) = proof_and_mod_imagefile(log,fullfilename,md_base_path,fpath,list[0],lines[list[1]],list[2],list[3])

                if modflag:
                    lines[list[1]] = line_mod
                    lines_changed = True
                # end if

                if modflag or len(ddict["action_text"]):
                    print(f"File    : {fullfilename}")
                    print(f"modflag : {modflag}")
                    print(f"iline   : {list_iline[i]}")
                    print(f"line    : <{lines[list[1]]}>")
                    print(f"line_mod: <{line_mod}>")
                    print(f"action  : <{ddict["action_text"]}>")
                    print("--------------------------------------------")
                # end if
            # end for
            if lines_changed:
                okay = hio.write_ascii(fullfilename,lines,'utf-8')
            # end if
        # end if
    return
# end def
def get_imagefiles_from_md(lines):
    """
    list_of_images_pos = get_imagefiles_from_md(lines)

    """

    list_of_images_pos = []
    list_iline = []

    for iline,line in enumerate(lines):

        # if hstr.such(line,"250801_Hochzeitsfoto_Eltern_mit") >= 0:
        #    print("gefunden")



        for ext in LIST_OF_EXTENSION:
            pext = '.'+ext
            index = line.lower().find(pext)

            index = hstr.such_in_quot(line, pext, "(", ")")

            if index < 0: # no found
                index = hstr.such_in_quot(line, pext, "[[", "]]")
            # end if

            if  index != -1:
                # print(line[index:])
                i1ext = index + len(pext)
                (proof,imagefilename,i0,i1) = proof_line_for_embedded_link(line,index,i1ext)

                if proof:
                    list_of_images_pos.append([imagefilename,iline,i0,i1])
                    list_iline.append(iline)
    return list_of_images_pos,list_iline
# end def
def proof_line_for_embedded_link(line,index,i1ext):
    """
    (proof,imagefilename,iline0,iline1) = proof_line_for_embedded_link(ext,index,line)
    """
    proof = False
    imagefilename = ""
    i0 = -1
    i1 = -1

    # if hstr.such(line,"SteckerFürLichtschalter") >= 0:
    #     print(line)
    # end if

    # 1. find '(',')'
    index_liste_2tuple = hstr.get_index_quot(line, '(',')')
    if len(index_liste_2tuple) != 0:
        for tup in index_liste_2tuple:
            if (tup[0] < index) and (tup[1] > index):
                # finde ![] vor ()
                (proof,imagefilename,i0,i1) = proof_embedded_linkt_first_type(line,tup[0],tup[1],i1ext)

                if proof:
                    break

    # 2. find '[',']'
    else:
        index_liste_2tuple = hstr.get_index_quot(line, '![[',']]')
        if len(index_liste_2tuple) != 0:
            for tup in index_liste_2tuple:
                i0 = tup[0]
                i1 = tup[1]
                imagefilename = line[tup[0]:tup[1]]
                proof = True

                # print(f"{line[tup[0]:tup[1]] = }")
                # print(f"{line = }")

                if proof:
                    break
                # end if
            # end for
        # end if
    # end if
    return (proof,imagefilename,i0,i1)
# end def
# end def
def proof_embedded_linkt_first_type(line,index0,index1,i1ext):
    """
    (proof,imagefilename,iline0,iline1) = proof_embedded_linkt_first_type(line,tup[0],tup[1],ext)
    """
    proof = False
    imagefilename = ""
    iline0 = -1
    iline1 = -1

    # Fine '[','[' before index0
    index_liste_2tuple = hstr.get_index_quot(line, '[', ']')
    if len(index_liste_2tuple) != 0:
        for tup in reversed(index_liste_2tuple):
            if tup[1] < index0:
                proof = True
            else:
                proof = False
            # end if

            if proof:
                # suche '!' vor '['
                txt = line[0:tup[0]]
                index = hstr.such(txt,'!')
                if index != -1:
                    proof = True
                else:
                    proof = False
                # end if
            # end if

            if proof:
                iline0 = index0
                iline1 = i1ext
                imagefilename = line[index0:i1ext]
                break
        # end for
    # end if
    return (proof,imagefilename,iline0,iline1)
# end def
def proof_and_mod_imagefile(log,fullfilename,md_base_path,fpath,imagefilename,line,i0,i1):
    """
    (modflag,line_mod) = proof_and_mod_imagefile(md_base_path,fpath,imagefilename,line,i0,i1)
    """
    modflag = False
    line_mod = ""

    if hstr.such(imagefilename,'%20') >= 0:
        s = 1
    imagefilename = hstr.change(imagefilename, '%20', ' ')

    md_base_path_list = os.path.normpath(md_base_path).split(os.sep)
    fpath_list        = os.path.normpath(fpath).split(os.sep)
    rel_fpath_list    = fpath_list[len(md_base_path_list):]
    ddict = {"md_base_path": md_base_path,
             "md_base_path_list": md_base_path_list,
             "fpath_list": fpath_list,
             "rel_fpath_list": rel_fpath_list,
             "log":log,
             "fullfilename":fullfilename}

    # Finde oder bilde den bilder-Pfad "_bilder" (ddict["bilder_path"])
    # und die relative Ebene (ddict["rel_ebenen"])
    ddict = find_or_build_bild_path(ddict,imagefilename)

    ddict = proof_and_correct_imagefile(ddict,imagefilename)

    if ddict["image_found"]:

        ddict = move_or_copy_imagefilename(ddict)

        if ddict["image_path_changed"]:

            modflag = True
            line_mod = modify_line_w_new_image_path(line,i0,i1,ddict)
            print(f"new_abs_image_path = {ddict["new_abs_image_path"]}")
        # end id
    # end if

    return (modflag,line_mod,ddict)
# end def
def find_or_build_bild_path(ddict,imagefilename):
    """
    ddict = find_or_build_bild_path(ddict)

    Bilde ddict["bilder_path_list"]
    Bilde ddict["rel_ebenen"]     relative von fpath zu bilder_path
    """
    if len(ddict["rel_fpath_list"]) == 0:

        bilder_path_list = copy.copy(ddict["md_base_path_list"])
        bilder_path_list.append(BILDER_PATH_NAME)
        rel_ebenen = 0

    elif len(ddict["rel_fpath_list"]) == 1:

        bilder_path_list =copy.copy( ddict["fpath_list"])
        bilder_path_list.append(BILDER_PATH_NAME)
        rel_ebenen = 0

    else:

        bilder_path_list = copy.copy(ddict["md_base_path_list"])
        bilder_path_list.append(ddict["rel_fpath_list"][0])
        bilder_path_list.append(BILDER_PATH_NAME)
        rel_ebenen = max(0,len(ddict["rel_fpath_list"])-1)
    # end def

    ddict["rel_ebenen"]  = rel_ebenen
    ddict["bilder_path_list"] = bilder_path_list
    ddict["bilder_path"]      =  hfp.build_path_from_list_with_forward_slash(bilder_path_list)

    if hfp.build_path(ddict["bilder_path"]) != hdef.OK:
        print(f"Das Zielverzeichnis {ddict["bilder_path"]} kann nicht erstellt werden")

    (fpath, fbody, fext) = hfp.get_pfe(imagefilename)

    ddict["image_file"] = fbody + '.' + fext
    ddict["full_image_file"] = imagefilename
    ddict["image_path"] = fpath
    ddict["image_path_list"] = os.path.normpath(fpath).split(os.sep)

    if hstr.such(fpath, "http") >= 0:
        ddict["imagefile_type"] = "http"
    else:
        ddict["imagefile_type"] = "local"
    # end if

    ddict["action_text"] = ""

    return ddict
# end def
def proof_and_correct_imagefile(ddict,imagefilename):
    """
    ddict = proof_and_correct_imagefile(ddict,imagefilename) ddict["abs_full_image_file"]
    """

    ddict["image_found"] = True

    ddict = bilde_abs_image_path(ddict)

    if ddict["imagefile_type"] == "http":


        if not hio.exist_http_file( ddict["abs_full_image_file"]):
            ddict["image_found"] = False
        # end if

    else:

        if not os.path.isfile( ddict["abs_full_image_file"]):

            fullfilename = hfp.find_file( ddict["abs_full_image_file"],ddict["md_base_path"])

            if fullfilename is None:

                (fpath, fbody, fext) = hfp.get_pfe(ddict["abs_full_image_file"])
                ddict["action_text"] = f"Aus Datei: <{ddict["fullfilename"]}>\nkann imageDatei: <{fbody+'.'+fext} nicht gefunden werden"
                # if ddict["fullfilename"] == 'K:/data/md/Kultur/GeleseneBücher/20190630_Murakami_GefährlicheGeliebte.md':
                #    v = 1
                ddict["log"].write_err(ddict["action_text"], screen=1)
                ddict["image_found"] = False
            else:
                fullfilename = hfp.build_path_with_forward_slash(fullfilename)
                (fpath, fbody, fext) = hfp.get_pfe(fullfilename)
                ddict["full_image_file"] = fullfilename
                ddict["image_path"] = fpath
                ddict["image_path_list"] = os.path.normpath(fpath).split(os.sep)

                ddict = bilde_abs_image_path(ddict)
            # end if
        # end if
    # end if
    return ddict
# end def
def bilde_abs_image_path(ddict):
    """
    ddict = zerlege_und_bilde_abs_image_path(ddict,imagefilename)
    """


    if ddict["imagefile_type"] == "local":
        image_path_list = copy.copy(ddict["image_path_list"])
        fpath_list      = copy.copy(ddict["fpath_list"])
        abs_image_path  = hfp.get_abs_dir(image_path_list, fpath_list)

        ddict["abs_image_path"]      = copy.copy(abs_image_path)
        ddict["abs_image_path_list"] = os.path.normpath(abs_image_path).split(os.sep)
        abs_full_image_file_list     = copy.copy(ddict["abs_image_path_list"])
        abs_full_image_file_list.append( ddict["image_file"])
        ddict["abs_full_image_file"] = hfp.build_path_from_list_with_forward_slash(abs_full_image_file_list)
    else: # http
        ddict["abs_image_path"]      = copy.copy(ddict["image_path"])
        ddict["abs_image_path_list"] = copy.copy(ddict["image_path_list"])
        ddict["abs_full_image_file"] = copy.copy(ddict["full_image_file"])
    # end if

    return ddict
# end def
def move_or_copy_imagefilename(ddict):
    """
    ddict = move_or_copy_imagefilename(ddict)
    ddict["new_abs_image_path"]
    ddict["image_path_changed"]
    """
    n = len(ddict["md_base_path_list"])
    liste = ddict["abs_image_path_list"][0:n]

    image_path_changed = False
    new_abs_image_path = ddict["abs_image_path"]

    if ddict["imagefile_type"] == "http":

        bilder_path_list = copy.copy(ddict["bilder_path_list"])
        new_abs_image_path = hfp.build_path_from_list_with_forward_slash(bilder_path_list)

        liste = copy.copy(ddict["bilder_path_list"])
        liste.append(ddict["image_file"])
        ddict["new_full_image_file"] = hfp.build_path_from_list_with_forward_slash(liste)

        okay = hio.read_http_file(ddict["abs_full_image_file"], ddict["new_full_image_file"] )
        ddict["action_text"] = f"http_copy: {ddict["abs_full_image_file"]} \n=> {ddict["new_full_image_file"]}"
        if okay == hdef.OKAY:
            image_path_changed = True
    else:
        if ddict["abs_image_path_list"] == ddict["bilder_path_list"]:

            pass
        elif  liste == ddict["md_base_path_list"]:
            # move
            bilder_path_list = copy.copy(ddict["bilder_path_list"])
            new_abs_image_path      = hfp.build_path_from_list_with_forward_slash(bilder_path_list)

            liste = copy.copy(ddict["bilder_path_list"])
            liste.append(ddict["image_file"])
            ddict["new_full_image_file"] = hfp.build_path_from_list_with_forward_slash(liste)

            okay = hfp.move_file(ddict["abs_full_image_file"], ddict["bilder_path"] )
            ddict["action_text"] = f"move: {ddict["abs_full_image_file"]} \n=> {ddict["bilder_path"]}"

            if okay == hdef.OKAY:
                image_path_changed = True
        else:
            # copy

            bilder_path_list = copy.copy(ddict["bilder_path_list"])
            new_abs_image_path = hfp.build_path_from_list_with_forward_slash(bilder_path_list)

            liste = copy.copy(ddict["bilder_path_list"])
            liste.append(ddict["image_file"])
            ddict["new_full_image_file"] = hfp.build_path_from_list_with_forward_slash(liste)

            okay = hfp.copy(ddict["abs_full_image_file"], ddict["new_full_image_file"])
            ddict["action_text"] = f"copy: {ddict["abs_full_image_file"]} \n=> {ddict["new_full_image_file"]}"
            if okay == hdef.OKAY:
                image_path_changed = True
        # end if
    # end if
    ddict["new_abs_image_path"] = new_abs_image_path
    ddict["image_path_changed"] = image_path_changed
    return ddict
# end def ddict["image_file"]
def modify_line_w_new_image_path(line, i0, i1, ddict):
    """
    line_mod = modify_line_w_new_image_pat(line, i0, i1, ddict)
    """
    bilder_path_list = copy.copy(ddict["bilder_path_list"])
    fpath_list       = copy.copy(ddict["fpath_list"])
    rel_dir = hfp.get_rel_dir(bilder_path_list,fpath_list)
    test = os.path.normpath(rel_dir)
    rel_file_list = hfp.build_list_from_path(rel_dir)
    rel_file_list.append(ddict["image_file"])

    new_image_full_file = hfp.build_path_from_list_with_forward_slash(rel_file_list)

    if i0 == 0:
        mod_line  = ""
    else:
        mod_line = line[0:i0]
    # end if

    mod_line += new_image_full_file
    mod_line += line[i1:]

    return mod_line

if __name__ == '__main__':
    MD_BASE_PATH = "K:/data/md"
    run_md_check_image_in_md_and_move(MD_BASE_PATH)

