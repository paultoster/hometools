import hfkt as h
from dataclasses import dataclass
import codecs
import tempfile
import shutil
import os
import urllib.request

""" def replace(file_path, pattern, subst):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(line.replace(pattern, subst))
    #Copy the file permissions from the old file to the new file
    copymode(file_path, abs_path)
    #Remove original file
    remove(file_path)
    #Move new file
    move(abs_path, file_path)
 """    
import sys

tools_path = "D:\\tools_tb\\python3"

if( tools_path not in sys.path ):
    sys.path.append(tools_path)

maindir = "D:/wdata/md"

@dataclass
class ImageObj:
  iline : int  = -1   # line number where found
  i0 : int  = -1      # first index in line  of first item (-1, if not set "![](abc.png)" )
  li : int  = 0       # length of first item (-1,  if not set "![](abc.png)")
  j0 : int  = -1      # first index in line  of second item (-1, if not set "![]()" )
  lj : int  = 0       # length  of second item (-1, if not set "![]()" )
  name : str  = ""    # first item name
  filename : str  = ""    # second item name
  filenamenew : str = ""  # changed item

def get_image_obj(line : str,ioff : int,iline : int):

  istart = line.find('![',ioff)
  if( istart == -1 ):
    return (None,0) 
  else:
    i0 = istart+2
    if( line[i0] == ']'):
      istart2 = i0 +1
      i0 = -1
      li = 0
      name = ""      
    else:
      i1 = line.find(']',i0)
      if(i1 == -1 ):
        return (None,0)
      else:
        istart2 = i1+1
        name = line[i0:i1]
        li = len(name)
      #endif
    #endif
      
    j0 = line.find('(',istart2)
    if( j0 == -1):
      return (None,0)
    else:
      j0 += 1
      j1 = line.find(')',j0)
      if( j1 == -1 ):
        return (None,0)
      else:
        iend = j1 + 1
        filename = line[j0:j1]
        lj = len(filename)
      #endif
    #endif

    imgobj = ImageObj(i0=i0,li=li,name=name,j0=j0,lj=lj,filename=filename,filenamenew="",iline=iline)
#     imgobj.i0 = i0
#    imgobj.li = li
#    imgobj.name = name
#    imgobj.j0 = j0
#    imgobj.lj = lj
#    imgobj.filename = filename
#    imgobj.filenamenew = ""
#    imgobj.iline = iline
     
    return (imgobj,iend)

  #endif
#enddef
def move_image_file(filename : str,immageObjects : ImageObj):
  
  (file_path,fbody,extension) = h.get_pfe(filename)
  file_path = h.change_max(file_path,"\\","/")
  file_path = h.elim_e(file_path,"/")

  for imgobj in immageObjects:

    (image_path,fbody,extension) = h.get_pfe(imgobj.filename)
    if( fbody == 'haversine_formula_150.fb2b87d122a4'):
      d=0

    image_path = h.change_max(image_path,"\\","/")
    image_path = h.elim_e(image_path,"/")

    if( len(image_path) ):
      if( image_path[0] == '.' ):
        if( len(image_path) <= 2):
          image_path = file_path
        else:
          image_path = os.path.join(file_path,image_path[2:])
          image_path = h.elim_e(image_path,"/")

    image_full_file = image_path + "/" + fbody + "." + extension 

    if( file_path.lower() == image_path.lower() ):
      
      filenamenew = fbody + "." + extension
      print(f"image in dir ! {image_full_file}")
    elif( len(image_path) == 0):
      
      filenamenew = image_full_file
      print(f"image in dir {image_full_file}")
    else:

      f = file_path + "/" + fbody + "." + extension
        
      if( (image_full_file.find("https://")>-1) or (image_full_file.find("http://")> -1)):
        try:
          print(f"copy http: {image_full_file}")
          resource = urllib.request.urlopen(image_full_file)
          output = open(f,"wb")
          output.write(resource.read())
          output.close()
          filenamenew = fbody + "." + extension
        except:
          print(f"copy http; failed")
          filenamenew = image_full_file
      else:
        print(f"move {image_full_file} => {f}")
        if( os.path.isfile(image_full_file)):
          shutil.move(image_full_file, f)
        else:
          print(f"image file {image_full_file} is not found")
        #endif
        filenamenew = fbody + "." + extension
      #endif
    #endif

    imgobj.filenamenew = filenamenew
  #endfor

  return immageObjects

def write_changes(filename : str,immageObjects : ImageObj):

  nobj = len(immageObjects)
  iobj = 0
  #Create temp file
  fh, abs_path = tempfile.mkstemp()
  with os.fdopen(fh,'w',encoding='utf-8') as new_file:
    with open(filename,encoding='utf-8') as old_file:
      for iline,line in enumerate(old_file):

        while( (iobj < nobj) and (iline == immageObjects[iobj].iline) ):

          if( immageObjects[iobj].j0 > -1 ):
            line = h.str_replace(line,immageObjects[iobj].filenamenew,immageObjects[iobj].j0,immageObjects[iobj].lj)
          #endif
          if( immageObjects[iobj].i0 > -1 ):
            line = h.str_replace(line,immageObjects[iobj].name,immageObjects[iobj].i0,immageObjects[iobj].li)
          #endif
          iobj += 1
          
        #endif
        new_file.write(line)
  #Copy the file permissions from the old file to the new file
  shutil.copymode(filename, abs_path)
  #Remove original file
  os.remove(filename)
  #Move new file
  shutil.move(abs_path, filename)
#enddef

def move_images(filename : str):

  (path,fbody,extension) = h.get_pfe(filename)

  if(fbody == "Gelenkschmiere"):
    a=0

  immageObjects = []

  with codecs.open(filename,'r',encoding='utf-8') as f:
    for iline,line in enumerate(f):
    
      ioff = 0
      icount = 0
      while line.find('![',ioff) > -1 :
        
        (iObj,ioff) = get_image_obj(line,ioff,iline)
        if( iObj == None):
          break
        #endif
        
        if( icount == 0 ):
          immageObjects.append(iObj)
        else:
          n  = len(immageObjects)
          i0 = n-icount 
          immageObjects.insert(i0, iObj)
        #endif
        icount += 1
      #endwhile
    #endfor
  #endwith
    
  if( len(immageObjects)):
    immageObjects = move_image_file(filename,immageObjects)
    write_changes(filename,immageObjects)

###########################################################################
# testen mit main
###########################################################################
if __name__ == '__main__':

  filelist = h.get_liste_of_files_in_dir(maindir,'md',1,[])

  for ifile,filename in enumerate(filelist):

    print(f"{ifile}.) {filename}")
    move_images(filename)
