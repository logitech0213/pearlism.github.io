import customtkinter as ctk
import keyboard
import mouse
import screeninfo
import configparser
import os
import time
import threading
import ctypes
import ast
import json as jsond  # json
import time  # sleep before exit
import binascii  # hex encoding
import platform  # check platform
import subprocess  # needed for mac device
from datetime import datetime

# Setting up config file
aim_check = False
x_value = 0
y_value = 0
left_value = 0
delay_value = 10
enabled = False

# Define a list of valid keys

# Create config file if it does not exist
if not os.path.isfile('config.txt'):
    print('config.txt file not found. Creating new one...')
    config = configparser.ConfigParser()
    config['hotkey'] = {'hotkey_on': 'f1', 'hotkey_off': 'f2'}
    config['loadouts'] = {}
    with open('config.txt', 'w') as configfile:
        config.write(configfile)
    input('Press any key to exit...')
    exit()
else:
    config = configparser.ConfigParser()
    config.read('config.txt')

# Recoil Macro App Main Window
class RecoilMacroApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Chair Hub Recoil")
        self.geometry('600x650')

        self.aim_check = False

        # Fading background color variables
        self.bg_fade_state = 0  # Start with first color
        self.bg_fade_interval = 2000  # Time in ms between color change
        self.bg_colors = ["#FF8C8C", "#800080", "#FF0000", "#FF69B4"]  # Colors to fade between

        # Create the GUI and start fading the background color
        self.configure(bg=self.bg_colors[self.bg_fade_state])
        self.fade_background_color()

        # Main Title Label
        self.title_label = ctk.CTkLabel(self, text="Chair Hub Recoil", text_color="white", font=("Arial", 20, "bold"))
        self.title_label.pack(pady=20)

        # UI Elements
        self.aim_check_button = ctk.CTkButton(self, text="Aim Check Off", command=self.toggle_aim_check, fg_color="#800080", hover_color="#FF2A2A")
        self.aim_check_button.pack(pady=10)

        self.title_label = ctk.CTkButton(self, text="F1 TO ACTIVATE - F2 TO DEACTIVATE", fg_color="#800080", hover_color="#FF2A2A")
        self.title_label.pack(pady=10)


        # X (Right) Control Slider and Value
        self.x_label = ctk.CTkLabel(self, text='X Control Value (Right)', text_color="white")
        self.x_label.pack(pady=5)
        self.x_slider = ctk.CTkSlider(self, from_=0, to=40, number_of_steps=40, command=self.update_x_value, fg_color="#800080", progress_color="#FF0000")
        self.x_slider.pack(pady=5)
        self.x_value_label = ctk.CTkLabel(self, text="X Value: 20", text_color="white")
        self.x_value_label.pack(pady=5)

        # Left Axis (Left) Control Slider and Value
        self.left_label = ctk.CTkLabel(self, text='Left Control Value (Left)', text_color="white")
        self.left_label.pack(pady=5)
        self.left_slider = ctk.CTkSlider(self, from_=-40, to=0, number_of_steps=40, command=self.update_left_value, fg_color="#800080", progress_color="#FF0000")
        self.left_slider.pack(pady=5)
        self.left_value_label = ctk.CTkLabel(self, text="Left Value: 20", text_color="white")
        self.left_value_label.pack(pady=5)

        # Y (Down) Control Slider and Value
        self.y_label = ctk.CTkLabel(self, text='Y Control Value (Down)', text_color="white")
        self.y_label.pack(pady=5)
        self.y_slider = ctk.CTkSlider(self, from_=0, to=40, number_of_steps=40, command=self.update_y_value, fg_color="#800080", progress_color="#FF0000")
        self.y_slider.pack(pady=5)
        self.y_value_label = ctk.CTkLabel(self, text="Y Value: 20", text_color="white")
        self.y_value_label.pack(pady=5)

        # Set Button
        self.set_button = ctk.CTkButton(self, text="Set Values", command=self.set_values, fg_color="#800080", hover_color="#FF2A2A")
        self.set_button.pack(pady=10)

        # Loadout Entry
        self.loadout_name_entry = ctk.CTkEntry(self, placeholder_text="Enter Loadout Name", fg_color="#800080", text_color="white")
        self.loadout_name_entry.pack(pady=10)

        # Save and Load Buttons
        self.save_button = ctk.CTkButton(self, text="Save Loadout", command=self.save_loadout, fg_color="#800080", hover_color="#FF2A2A")
        self.save_button.pack(pady=5)
        self.load_button = ctk.CTkButton(self, text="Load Loadout", command=self.load_loadout, fg_color="#800080", hover_color="#FF2A2A")
        self.load_button.pack(pady=5)

        # Hotkeys for toggling
        keyboard.add_hotkey("f1", self.enable_macro)
        keyboard.add_hotkey("f2", self.disable_macro)

        # Start macro thread
        self.macro_thread = threading.Thread(target=self.macro_task)
        self.macro_thread.daemon = True
        self.macro_thread.start()

    def fade_background_color(self):
        """This method will change the background color every `self.bg_fade_interval`."""
        self.configure(bg=self.bg_colors[self.bg_fade_state])
        self.bg_fade_state = (self.bg_fade_state + 1) % len(self.bg_colors)  # Loop through colors
        self.after(self.bg_fade_interval, self.fade_background_color)  # Schedule the next color change

    def set_values(self):
        global x_value, y_value, delay_value, left_value
        x_value = min(int(self.x_slider.get()), 40)
        left_value = max(int(self.left_slider.get()), -40)
        y_value = min(int(self.y_slider.get()), 40)
        print(f"Values set - X: {x_value}, Left: {left_value}, Y: {y_value}, Delay: {delay_value}ms")

    def toggle_aim_check(self):
        global aim_check
        aim_check = not aim_check
        self.aim_check_button.configure(text="Aim Check On" if aim_check else "Aim Check Off")

    def save_loadout(self):
        global x_value, y_value, left_value, delay_value
        name = self.loadout_name_entry.get()
        if name:
            config['loadouts'][name] = f'[{x_value},{left_value},{y_value},{delay_value}]'
            with open('config.txt', 'w') as configfile:
                config.write(configfile)
            print(f"Loadout '{name}' saved!")

    def load_loadout(self):
        global x_value, y_value, left_value, delay_value
        name = self.loadout_name_entry.get()
        if name in config['loadouts']:
            loadout = ast.literal_eval(config['loadouts'][name])
            x_value, left_value, y_value, delay_value = loadout
            self.x_slider.set(x_value)
            self.left_slider.set(left_value)
            self.y_slider.set(y_value)
            print(f"Loadout '{name}' loaded!")

    def enable_macro(self):
        global enabled
        enabled = True
        print("Macro Enabled!")

    def disable_macro(self):
        global enabled
        enabled = False
        print("Macro Disabled!")

    def macro_task(self):
        while True:
            if enabled:
                if aim_check:
                    if ctypes.windll.user32.GetAsyncKeyState(0x01) & 0x8000 and ctypes.windll.user32.GetAsyncKeyState(0x02) & 0x8000:
                        self.move_rel(x_value + left_value, y_value)
                else:
                    if ctypes.windll.user32.GetAsyncKeyState(0x01) & 0x8000:
                        self.move_rel(x_value + left_value, y_value)
            time.sleep(delay_value / 1000)

    def move_rel(self, x, y):
        ctypes.windll.user32.mouse_event(0x0001, x, y, 0, 0)

    def update_x_value(self, value):
        self.x_value_label.configure(text=f"X Value: {int(float(value))}")

    def update_left_value(self, value):
        self.left_value_label.configure(text=f"Left Value: {int(float(value))}")

    def update_y_value(self, value):
        self.y_value_label.configure(text=f"Y Value: {int(float(value))}")

if __name__ == "__main__":
    app = RecoilMacroApp()
    app.mainloop()
