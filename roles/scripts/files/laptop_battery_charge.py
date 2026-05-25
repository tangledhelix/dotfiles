#!/usr/bin/env python
# coding=UTF-8

# I use the Solarized Dark theme in iTerm2, colors may look weird elsewhere
colors = {
    'blue': '%F{blue}',
    'cyan': '%F{cyan}',
    'green': '%F{green}',
    'red': '%F{red}',
    'white': '%F{white}',
    'yellow': '%F{yellow}',
    'reset': '%f'
}

# battery meter color for high, medium, low battery charge level
# charged is fully charged, charging is currently charging
battery_colors = {
    'full': colors['cyan'],
    'medium': colors['yellow'],
    'low': colors['red'],
    'charged': colors['yellow'],
    'charging': colors['white']
}

import math
import subprocess
import sys

p = subprocess.Popen(['ioreg', '-rc', 'AppleSmartBattery'], stdout=subprocess.PIPE)
output = p.communicate()[0]

for line in output.splitlines():
    if 'MaxCapacity' in line:
        max_capacity = line.split()[2]
    if 'CurrentCapacity' in line:
        current_capacity = line.split()[2]
    if 'IsCharging' in line:
        is_charging = line.split()[2]
    if 'FullyCharged' in line:
        fully_charged = line.split()[2]

current_charge = float(current_capacity) / float(max_capacity)
charge_threshold = int(math.ceil(10 * current_charge))

total_slots, slots = 10, []
filled = int(math.ceil(charge_threshold * (total_slots / 10.0))) * u'▸'
empty = (total_slots - len(filled)) * u'▹'

battery_level_color = (
    battery_colors['full'] if len(filled) > 6
    else battery_colors['medium'] if len(filled) > 4
    else battery_colors['low']
)

battery_output = (battery_level_color + filled + empty + colors['reset']).encode('utf-8')

charged_output = (battery_colors['charged'] + u'⚡' + colors['reset']).encode('utf-8')
charging_output = (battery_colors['charging'] + u'⚡' + colors['reset']).encode('utf-8')

if fully_charged == 'Yes':
    final_output = charged_output
elif is_charging == 'Yes':
    final_output = battery_output + ' ' + charging_output
else:
    final_output = battery_output

sys.stdout.write(final_output)
