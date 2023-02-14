
#
# import hlpfu_str hs
#
#---------------------------------------------------
# i0 = hs.str_such(txt,muster,regel) 
#
# Suche nach dem Muster in dem Text nach der Regel:
#
# Input:
# text    string  zu durchsuchender String
# muster  string  muster nachdem gesucht wird
# regel   string  Regel nach der gesucht wird:
#                vs  vorwaerts muster suchen
#                vn  vorwaerts suchen, wann muster nicht mehr
#                    vorhanden ist
#                rs  rueckwrts muster suchen
#                rn  rueckwaerts suchen, wann muster nicht mehr
#                    vorhanden ist
#
# Output:
# index   int     Index im String in der die Regel wahr geworden ist
#                oder -1 wenn die Regel nicht wahr geworden ist
#----------------------------------------------------

#-------------------------------------------------------
def str_such(text,muster,regel="vs"):    
  # Suche nach dem Muster in dem Text nach der Regel:
  #
  # Input:
  # text    string  zu durchsuchender String
  # muster  string  muster nachdem gesucht wird
  # regel   string  Regel nach der gesucht wird:
  #                vs  vorwaerts muster suchen
  #                vn  vorwaerts suchen, wann muster nicht mehr
  #                    vorhanden ist
  #                rs  rueckwrts muster suchen
  #                rn  rueckwaerts suchen, wann muster nicht mehr
  #                    vorhanden ist
  #
  # Output:
  # index   int     Index im String in der die Regel wahr geworden ist
  #                oder -1 wenn die Regel nicht wahr geworden ist

  lt = len(text)
  lm = len(muster)

  if (regel.find("v") > -1) or (regel.find("V") > -1):
    v_flag = 1
  else:
    v_flag = 0
  #endif

  if (regel.find("n") > -1) or (regel.find("n") > -1):
    n_flag = 1
  else:
    n_flag = 0
  #endif

  if v_flag == 1:  # vorwaerts

    if n_flag == 1: # nicht mehr vorkommen

      ireturn = -1
      for i in range(0,lt,1):

        if( text[i:i+lm].find(muster) == -1 ):
          ireturn = i
          break
        #endif
      #endfor
      return ireturn

    else: #soll vorkommen

      ireturn = text.find(muster)
      # print "ireturn = %i" % ireturn
      return ireturn
    #endif

  else: # rueckwaerts

    if n_flag == 1:
      ireturn = -1
#     print "lm=%i" % lm
#     print "lt=%i" % lt
      for i in range(0,lt,1):
#       print "i=%i" % i
        i0 = text.rfind(muster,0,lt-i)
#       print "i0=%i" % i0
#       print "lt-lm-i=%i" % (lt-lm-i)

        if i0 < lt-lm-i:
          ireturn = lt-i-1
          break
        #endif
      #endfor
      return ireturn
    else:
      ireturn = text.rfind(muster)
      return ireturn
    #endif
  #endif
#enddef