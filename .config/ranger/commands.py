import subprocess
import json

from ranger.api.commands import Command

def lsblk():
    output = subprocess.check_output([
        'lsblk', 
        '-a',
        '-J',
        '-o',
        ','.join([
            'NAME',
            'HOTPLUG',
            'LABEL',
            'SIZE',
            'TYPE',
            'MOUNTPOINTS',
            'MODEL',
            'PARTLABEL',
            'FSTYPE'
        ])
    ])

    return json.loads(output)

def hotpluggable_parts():
    blk = lsblk()

    for device in blk.get('blockdevices', []):
        if not device['hotplug']:
            continue

        for child in device.get('children', []):
            yield {
                'name'  : child['name'],
                'label' : child['label'] or child['partlabel'],
                'size'  : child['size'],
                'fs'    : child['fstype'],
                'model' : device['model'],
                'mounts': list(filter(None, child.get('mountpoints', []))),
            }


class umount(Command):

    def execute(self):
        device = self.args[1]

        if device:
            self.fm.execute_command(
                ['udisksctl',
                'unmount',
                '-b',
                device])

    def tab(self, tabnum):
        return (
            '%s /dev/%s (%s) %s (%s)' % (
                self.__class__.__name__, 
                part['name'],
                ' - '.join(filter(None, [part['model'], part['label']])),
                part['size'],
                ','.join(part['mounts'])
            )
            for part in hotpluggable_parts() if part['mounts']
        )


class mount(Command):
    escape_macros_for_shell = True

    def execute(self):
        device= self.args[1]

        if device:
            self.fm.execute_command(
                ['udisksctl',
                 'mount',
                 '-b',
                 device])

    def tab(self, tabnum):
        return (
            '%s /dev/%s (%s) %s' % (
                self.__class__.__name__, 
                part['name'],
                ' - '.join(filter(None, [part['model'], part['label']])),
                part['size']
            )
            for part in hotpluggable_parts() if not part['mounts']
        )
