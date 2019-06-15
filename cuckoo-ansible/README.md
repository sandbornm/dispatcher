# Cuckoo Ansible Playbook
---
## Description 
> Deploying a configured version of Cuckoo Sandbox on a remote/local server automatically can save a lot of time during the process of migrating between servers in future and also helps up in CI/CD process. 
---
## Test 
Please change the following parameters for the remote-server you want to install Cuckoo. 
- Please add your host IP address under `[webservers]` directive in hosts file. 
- Copy your SSH public-key to the *authorized_keys* under `~/.ssh/authorized_keys` of remote machine 
    - You can use the following command to do the job for you. 
> `ssh-copy-id ubuntu@192.168.40.128`
- Finally, so as to start the deployment process, issue the following: 
> `ansible-playbook -i hosts test.yml -vvv --ask-become-pass` 
---
## TODO List 
- [x] Installing cuckoo pip under virtualenv 
- [x] Installing volatility plugin and profiles for memory forensics 
- [x] Configuring VBox environment for cuckoo user 
- [x] Configuring tcpdump to use CAPs 
- [ ] iptable fw rules for guest iface internet-access 
- [ ] add vbox config profile based our needs (configurable) 

