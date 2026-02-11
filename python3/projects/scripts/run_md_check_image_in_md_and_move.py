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

MD_BASE_PATH      = "K:/data/md"
LIST_OF_EXTENSION = ["png","jpg","jpeg","webp"]
BILDER_PATH_NAME  = "_bilder"
def run_md_check_image_in_md_and_move(md_base_path):
    '''

    '''
    liste = hfp.find_file_pattern('*.md', md_base_path)
    for i,item in enumerate(liste):
        # print(f"Nr.: {i+1} {item}")

        if i == 5:
            print("Pause")
        # end if

        fullfilename = hfp.build_path_with_forward_slash(item)

        (fpath, fbody, fext) = hfp.get_pfe(fullfilename)

        (okay, lines) = hio.read_ascii_build_list_of_lines(file_name=fullfilename)

        if okay == hdef.OKAY:
            # [[imagefilename,iline,i0,i1]]
            list_of_images_pos,list_iline = get_imagefiles_from_md(lines)

            for i,list in enumerate(list_of_images_pos):

                (modflag,line_mod) = proof_and_mod_imagefile(md_base_path,fpath,list[0],lines[list[1]],list[2],list[3])


                print(f"File    : {fullfilename}")
                print(f"modflag : {modflag}")
                print(f"iline   : {list_iline[i]}")
                print(f"line    : <{lines[list[1]]}>")
                print(f"line_mod: <{line_mod}>")
                print("--------------------------------------------")

    return
# end def
def get_imagefiles_from_md(lines):
    """
    list_of_images_pos = get_imagefiles_from_md(lines)

    """

    list_of_images_pos = []
    list_iline = []

    for iline,line in enumerate(lines):

        for ext in LIST_OF_EXTENSION:
            pext = '.'+ext
            index = line.lower().find(pext)

            if  index != -1:
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
    iline0 = -1
    iline1 = -1
    # 1. find '(',')'
    index_liste_2tuple = hstr.get_index_quot(line, '(',')')
    if len(index_liste_2tuple) != 0:
        for tup in index_liste_2tuple:
            if (tup[0] < index) and (tup[1] > index):
                # finde ![] vor ()
                (proof,imagefilename,iline0,iline1) = proof_embedded_linkt_first_type(line,tup[0],tup[1],i1ext)

    # 2. find '[',']'
    else:
        index_liste_2tuple = hstr.get_index_quot(line, '![[',']]')
        if len(index_liste_2tuple) != 0:
            for tup in index_liste_2tuple:
                iline0 = tup[0]
                iline1 = tup[1]
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
    return (proof,imagefilename,iline0,iline1)
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
def proof_and_mod_imagefile(md_base_path,fpath,imagefilename,line,i0,i1):
    """
    (modflag,line_mod) = proof_and_mod_imagefile(md_base_path,fpath,imagefilename,line,i0,i1)
    """
    modflag = False
    line_mod = ""

    md_base_path_list = os.path.normpath(md_base_path).split(os.sep)
    fpath_list        = os.path.normpath(fpath).split(os.sep)
    rel_fpath_list    = fpath_list[len(md_base_path_list):]
    ddict = {"md_base_path_list": md_base_path_list,
             "fpath_list": fpath_list,
             "rel_fpath_list": rel_fpath_list}

    # Finde oder bilde den bilder-Pfad "_bilder" (ddict["bilder_path"])
    # und die relative Ebene (ddict["rel_ebenen"])
    ddict = find_or_build_bild_path(ddict)

    ddict = zerlege_und_bilde_abs_image_path(ddict,imagefilename)

    ddict = move_or_copy_imagefilename(ddict)

    if ddict["image_path_changed"]:

        modflag = True
        line_mod = modify_line_w_new_image_path(line,i0,i1,ddict)
        print(f"new_abs_image_path = {ddict["new_abs_image_path"]}")
    # end id
    return (modflag,line_mod)
# end def
def find_or_build_bild_path(ddict):
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

    return ddict
# end def
def zerlege_und_bilde_abs_image_path(ddict,imagefilename):
    """
    ddict = zerlege_und_bilde_abs_image_path(ddict,imagefilename)
    """

    # Zerlege imagefilename
    (fpath, fbody, fext) = hfp.get_pfe(imagefilename)

    ddict["full_image_file"] = imagefilename
    ddict["image_path"] = fpath
    test = os.path.normpath(fpath)
    ddict["image_path_list"] = os.path.normpath(fpath).split(os.sep)
    ddict["image_file"] = fbody+'.'+fext

    image_path_list = copy.copy(ddict["image_path_list"])
    fpath_list      = copy.copy(ddict["fpath_list"])
    abs_image_path  = hfp.get_abs_dir(image_path_list, fpath_list)

    ddict["abs_image_path"]      = copy.copy(abs_image_path)
    ddict["abs_image_path_list"] = os.path.normpath(abs_image_path).split(os.sep)
    abs_full_image_file_list     = copy.copy(ddict["abs_image_path_list"])
    abs_full_image_file_list.append( ddict["image_file"])
    ddict["abs_full_image_file"] = hfp.build_path_from_list_with_forward_slash(abs_full_image_file_list)

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

    if ddict["image_path_list"] == ddict["bilder_path_list"]:

        pass
    elif  liste == ddict["md_base_path_list"]:
        # move
        print(f"-----------------------------")
        print(f"move: {ddict["image_path_list"] = }")
        bilder_path_list = copy.copy(ddict["bilder_path_list"])
        new_abs_image_path      = hfp.build_path_from_list_with_forward_slash(bilder_path_list)

        liste = copy.copy(ddict["bilder_path_list"])
        liste.append(ddict["image_file"])
        ddict["new_full_image_file"] = hfp.build_path_from_list_with_forward_slash(liste)

        okay = hdef.OKAY  # hfp.move_file(ddict["full_image_file"], ddict["new_full_image_file"])

        if okay == hdef.OKAY:
            image_path_changed = True
    else:
        # copy
        print(f"-----------------------------")
        print(f"copy: {ddict["image_path_list"] = }")
        bilder_path_list = copy.copy(ddict["bilder_path_list"])
        new_abs_image_path = hfp.build_path_from_list_with_forward_slash(bilder_path_list)

        liste = copy.copy(ddict["bilder_path_list"])
        liste.append(ddict["image_file"])
        ddict["new_full_image_file"] = hfp.build_path_from_list_with_forward_slash(liste)

        okay = hdef.OKAY # hfp.copy(ddict["full_image_file"], ddict["new_full_image_file"])

        if okay == hdef.OKAY:
            image_path_changed = True
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
    run_md_check_image_in_md_and_move(MD_BASE_PATH)

