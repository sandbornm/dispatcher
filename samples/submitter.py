#!/usr/bin/env python3
import glob
import os
import logging
import subprocess

l = logging.getLogger(__name__)
l.setLevel(logging.INFO)

task_id = []

configs = ['win7x86_conf1',
			'win7x86_conf2',
			'win7x86_conf3',
			'win7x86_conf4']
			# 'winxpx64',
			# 'winxpx86',
			# 'win7x86',
			# 'win7x64']

config = os.environ['CONFIG']
assert config in configs, f"{config} is invalid config"
l.info(f"executing on config {config}")

def submit():


    flist = glob.glob('./100_evasion/*/*.bin')
    for f in flist:
        subprocess.call(['cuckoo', 'submit', '--timeout', '240', '--machine',
				config, os.path.abspath(f)])
    #    task_id.append(db.add_path(file_path=os.path.abspath(f), timeout=60))
    #    r = requests.post()
    #return task_id

if __name__ == '__main__':
    #db = Database()
    #set_cwd(os.path.expanduser('~/.cuckoo'))
    #db.connect(dsn="sqlite:///cuckoo.db")
    submit()
    #tasks = submit(db)
