#-------------------------------------------------------------------------------
# Name:        mab_file
# Purpose:     read or write Adress from file in mab-fileformat
#              Thunderbirds Adressfileformat abook.mab
#              Fileformat is Mork
#
# Author:      tom
#
# Created:     20.10.2010
# Copyright:   (c) tom 2010
# Licence:     <your licence>
#
# __init__(self,file_name,purpose)
# file_name    name of mab-File for writing or reading
# purpose      'r' for read
#              'w' for write
#-------------------------------------------------------------------------------
#!/usr/bin/env python

class mab_file:
    def __init__(self,file_name,purpose):

    def read():
    ''' Liest Thunderbird mab-File
        Mork
      return(error,liste)
      error = 0                => okay
      error = ERR_NO_FILE(1)
  '''
  error = 0
  liste = []
  lines = []
  if(not os.path.isfile(file_name)):
    error = ERR_NO_FILE
    print "File:%s nor found" % file_name
    return (error,liste)

  f    = open(file_name,"r")
  tact = ""
  type = 0
  line = f.readline()
  while line:
    line = f.readline()
    tact += line.lstrip("\n")

    # header
    if( type == 0 ):

      if( re.search('mdb:mork:z',tact) ):
        type = 1
        tact = ""
    # feldzuordnung Feldname suchen
    elif( type == 1 ):
      sre = re.search("<(a=c)>",tact) #Ist damit gekennzeichnet
      a   = re.search("<",tact)
      if(   a and sre and a.span()[0] < sre.span()[0] ):

        tact = tact[0:sre.span()[0]]+tact[sre.span()[1]:]
        # Kommentar
        sre = re.search("\\\\",tact)
        if( sre ):
          tact = tact[0:sre.span()[0]]
        notfound = 1
        while( notfound ):
          line = f.readline()
          sre = re.search(">",line)
          if( sre ):
            tact += line[0:sre.span()[0]+1

        tacline
          type = 2
      if( i0 > -1 ):
        tact = tact[i0:]
        i0 = such(tact,"<(a=c)>","vs")
        if( i0 > -1 ):
          feld = 1
          tact = ""



        type = 2
        field = 1
      if( )

    print line




  return (error,liste)


if __name__ == '__main__':
    main()
