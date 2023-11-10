#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      lino
#
# Created:     07.11.2023
# Copyright:   (c) lino 2023
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import os, sys

tools_path = os.getcwd()
if( tools_path not in sys.path ):
    sys.path.append(tools_path)

from hfkt import hfkt_log as hlog

def main():
    pass

if __name__ == '__main__':
    main()
