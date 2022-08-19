#!/usr/bin/env python3

import json
import subprocess

result = subprocess.run(['wpctl', 'get-volume', '@DEFAULT_AUDIO_SINK@'],
                        stdout=subprocess.PIPE)
result = result.stdout.decode('utf-8').split()
percentage = int(float(result[1]) * 100)

if '[MUTED]' in result:
    output = {'percentage': percentage, "alt": "mute"}
else:
    output = {'percentage': percentage, "alt": "nomute"}

print(json.dumps(output))
