#!/usr/bin/env python3
from zipfile import ZipFile
import os
import json
import re
import logging

l = logging.getLogger(name=__name__)
l.setLevel(logging.DEBUG)

PASSWD = b"MalwareBehaviorReports"
REPORT_PATH = '/var/malware/wild-reports.zip'

def main():

    with ZipFile(REPORT_PATH, 'r') as f:
        inflst = f.infolist()
        evasion_dict = dict()
        for inf in inflst:
            if '-report-win7.json' in inf.filename:
                src = f.read(inf, pwd=PASSWD)
                content = json.loads(src.decode('utf-8'))
                try:
                    mal_activity = content['data']['malicious_activity']
                except KeyError:
                    continue
                ev_artifacts = []
                for k in mal_activity:
                    if "evasion: " in k.lower():
                        ev_artifacts.append(k)
                if ev_artifacts:
                    key = re.findall(r'[a-f0-9]{40}', os.path.basename(inf.filename))[0]
                    evasion_dict[key] = ev_artifacts
                    l.debug(key)
                    print(key)

        with open('EvasionFilter.json', 'a') as fp:
            json.dumps(evasion_dict, fp)

if __name__ == '__main__':
    main()
