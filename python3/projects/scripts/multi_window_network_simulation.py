import FreeSimpleGUI as sg
import datetime
import random

# Displaying information using PySimpleGUI

# 1 - Debug output by calling Print
# for x in range(20):
#     sg.Print(x, datetime.datetime.now())

# 2 - A custom window with Output Element

# STEP 1 define the layout
layout = [[sg.Text('This is your custom window... print output is below')],
          [sg.Output(size=(200, 20))],
          [sg.Text(size=(200, 1), key='-LINE-OUTPUT-')],
          [sg.Button('PrintSomething'), sg.Button('Popup'), sg.Button('Exit')]]

# STEP 2 - create the window
window = sg.Window('My new window', layout)

# STEP3 - the event loop
count = 0
while True:
    random_number = random.randint(0, 10)

    event, values = window.read(timeout=0)  # Read the event that happened and the values dictionary
    if (count % 10000) == 0:
        print(f'{count}   {datetime.datetime.now()}')
        window['-LINE-OUTPUT-'].update(f'{count}   {datetime.datetime.now()}')  # 4 - Update a Text element

    count += 1

    if event in (None, 'Exit'):  # If user closed window with X or if user clicked "Exit" button then exit
        break
    elif event == 'Popup':  # 3 - Display using a popup window
        sg.popup(f'{random_number}   {datetime.datetime.now()}')
    elif event == 'PrintSomething':
        print(f'{random_number}   {datetime.datetime.now()}')
        window['-LINE-OUTPUT-'].update(f'{random_number}   {datetime.datetime.now()}')  # 4 - Update a Text element


# import FreeSimpleGUI as sg
#
# sg.theme('GreenTan') # give our window a spiffy set of colors
#
# layout = [[sg.Text('Your output will go here', size=(40, 1))],
#           [sg.Output(size=(110, 30), font=('Helvetica 10'))],
#           [sg.MLine(size=(60, 5), enter_submits=True, key='-QUERY-', do_not_clear=False),
#            sg.Button('SEND', button_color=(sg.YELLOWS[0], sg.BLUES[0]), bind_return_key=True),
#            sg.Button('EXIT', button_color=(sg.YELLOWS[0], sg.GREENS[0]))]]
#
# window = sg.Window('Chat window', layout, font=('Helvetica', ' 13'), default_button_element_size=(8, 2))
#
# while True:     # The Event Loop
#     event, value = window.read()
#     if event in (None, 'EXIT'):            # quit if exit button or X
#         break
#     if event == 'SEND':
#         query = value['-QUERY-'].rstrip()
#         # EXECUTE YOUR COMMAND HERE
#
#
# import FreeSimpleGUI as sg
#
# """
#   DESIGN PATTERN 2 - Multi-read window. Reads and updates fields in a window
# """
#
# sg.theme('Dark Amber')    # Add some color for fun
#
# # 1- the layout
# layout = [[sg.Text('Your typed chars appear here:'), sg.Text(size=(15,1), key='-OUTPUT-')],
#           [sg.Input(key='-IN-')],
#           [sg.Button('Show'), sg.Button('Exit')]]
#
# # 2 - the window
# window = sg.Window('Pattern 2', layout)
#
# # 3 - the event loop
# while True:
#     event, values = window.read()
#     print(event, values)
#     if event == sg.WIN_CLOSED or event == 'Exit':
#         break
#     if event == 'Show':
#         # Update the "output" text element to be the value of "input" element
#         window['-OUTPUT-'].update(values['-IN-'])
#
#         # In older code you'll find it written using FindElement or Element
#         # window.FindElement('-OUTPUT-').Update(values['-IN-'])
#         # A shortened version of this update can be written without the ".Update"
#         # window['-OUTPUT-'](values['-IN-'])
#
# # 4 - the close
# window.close()

# import FreeSimpleGUI as sg
# from random import randint as randint
# from random import choice as choice
# import time
# import string
#
# """
#     PySimpleGUI simulation of a network communications monitoring and manipulation of network connections
#     10 lines of Network connections are shown
#     Can click on a button to bring up a detailed view for the connection
#     In the detailed view can take actions on the connection or close the detailed view
#     MUCH of this code is in creating the random values for names, input/output stats, etc
#     The important overall architecture is:
#              Mainwindow runs every 100 ms
#              If 'detail' button is clicked in main window
#                  A new "detail" window is created
#              All active "detail" windows are processed at the end of the main event loop (every 100ms)
#              Optional POLL_TIME paramter can be used to
# """
#
# NUM_CONNECTIONS = 10
# POLL_TIME = 100
#
# def initialize_window(name, slot):
#     """
#     Starts up a detailed window
#     :param name: Text name of the connection
#     :param slot: The "Slot Number" of the conection
#     :return: window: The PySimpleGUI Window object for this window
#     """
#     layout = [
#                 [sg.Text(str(name) + ' Detailed Information')],
#                 [sg.Text('Input bytes '), sg.Text('', key='_INPUT_BYTES_')],
#                 [sg.Text('Output bytes '), sg.Text('', key='_OUTPUT_BYTES_')],
#                 [sg.Text('', size=(20,1), key='_ACTION_RESULT_')],
#                 [sg.Button('Action 1'), sg.Button('Action 2'), sg.Button('Close')],
#              ]
#     window = sg.Window('Details '+ str(name),location=(225*slot, 0)).Layout(layout)
#     return window
#
#
# def process_window(window:sg.Window):
#     """
#     Processes events, button clicks, for a detailed window
#     :param window: The PySimpleGUI Window to work with
#     :return: event: The button clicked or None if exited
#     """
#     event, values = window.Read(timeout=0)          # Read without waiting for button clicks
#     if event in (None, 'Close'):
#         window.Close()
#         return None
#     elif event == 'Action 1':
#         window.Element('_ACTION_RESULT_').Update('Action 1 result = '+str(randint(0,1000)))
#     elif event == 'Action 2':
#         window.Element('_ACTION_RESULT_').Update('Action 2 result = '+str(randint(-1000,0)))
#     # show dummy stats so can see window is live and operational
#     window.Element('_INPUT_BYTES_').Update(randint(0,40000))
#     window.Element('_OUTPUT_BYTES_').Update(randint(0,40000))
#     return event        # return the button clicked
#
#
# def main_window():
#     """
#     Runs the main window
#     :return:
#     """
#     # create the GUI elements for each possible connection
#     connection_rows = []
#     for i in range(NUM_CONNECTIONS):
#         connection_rows.append([sg.Text('', size=(12,1), key='_TEXT_'+str(i)),
#                             sg.Button('Details', key='_DETAILS_'+str(i))],)
#     # The main window layout
#     layout = [ [sg.Text('Active Network Connections')],
#                 *connection_rows,
#                [sg.Button('Exit')]]
#
#     window = sg.Window('Main Window').Layout(layout)
#
#     # Loop reading events from a network connection
#     active_connectios = [None for i in range(NUM_CONNECTIONS)]      # list of active connections (names)
#     detail_window_list = [None for i in range(NUM_CONNECTIONS)]     # list of detailed windows that are open
#     start_time = time.time()
#     # MAIN WINDOW EVENT LOOP
#     while True:
#         # ----------------------------- Process Main Window -----------------------------
#
#         event, values = window.Read(timeout=POLL_TIME)      # run main window every 100ms
#         if event in (None, 'Exit'):
#             break
#         print(event) if event != sg.TIMEOUT_KEY else None
#         # Process Details Button Click
#         if event.startswith('_DETAILS_') and active_connectios[int(event[-1])]:
#             slot = int(event[-1])
#             if active_connectios[slot]:
#                 if detail_window_list[slot] is None:
#                     detail_window_list[slot] = initialize_window(active_connectios[slot], slot)
#         # ------------------- Simulate Network Activity Every 3 seconds ----------------
#         time_delta = round(time.time() - start_time)
#         if time_delta % 3 == 0:
#             slot = randint(0,NUM_CONNECTIONS-1)
#             active_connectios[slot] = ''.join([choice(string.ascii_lowercase) for i in range(5)]) if randint(0,5) else ''
#             window.Element('_TEXT_'+str(slot)).Update(active_connectios[slot])
#         # -------------------------- Process all Detailed Windows ----------------------
#         for i in range(len(detail_window_list)):
#             if detail_window_list[i]:
#                 rc = process_window(detail_window_list[i])
#                 if rc is None:        # if closed then remove the window for active list
#                     detail_window_list[i] = None
#     # After the Event Loop
#     window.Close()
#
# if __name__ == '__main__':
#     main_window()