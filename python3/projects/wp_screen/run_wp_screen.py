
import os, sys


t_path, _ = os.path.split(__file__)
tools_path = t_path + "\\.."
if (tools_path not in sys.path):
    sys.path.append(tools_path)
# endif

import wp_screen_command
import wp_screen_base


base_path = "D:/data/wp"
rd = wp_screen_base.WPScreen(base_path)

# run Command
wp_screen_command.wp_screen_command(rd)

