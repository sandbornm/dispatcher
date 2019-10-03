#!/usr/bin/env python3
import glob
import os
import logging
import subprocess

l = logging.getLogger(__name__)
l.setLevel(logging.INFO)

task_id = []

def submit():
    flist = glob.glob('./100_evasion/*/*.bin')
    for f in flist:
        subprocess.call(['cuckoo', 'submit', '--timeout', '240', '--machine',
                         'win7x86_conf4', os.path.abspath(f)])
    #    task_id.append(db.add_path(file_path=os.path.abspath(f), timeout=60))
    #    r = requests.post()
    #return task_id

if __name__ == '__main__':
    #db = Database()
    #set_cwd(os.path.expanduser('~/.cuckoo'))
    #db.connect(dsn="sqlite:///cuckoo.db")
    submit()
    #tasks = submit(db)
