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

## Important 
if your ssh\_key is protected by password, you need to install ssh-askpass on
your local, in this way your key will be loaded inside ssh-agent of the current
session you're already in and it will be used to SSH forward your agent to
securely clone the private repo of the vmcloak project into your deployment
environment. 

`sudo apt-get install ssh-askpass` 

## Note 
In case you received an error regarding pyopenssl: 
`sudo python -m easy_install --upgrade pyOpenSsl` 

---
## TODO List 
- [x] Installing cuckoo pip under virtualenv 
- [x] Installing volatility plugin and profiles for memory forensics 
- [x] Configuring VBox environment for cuckoo user 
- [x] Configuring tcpdump to use CAPs 
- [x] iptable fw rules for guest iface internet-access 
- [x] jinja2 temaplte for cuckoo.conf added! 
- [x] add vbox config profile based on our needs (configurable) 
- [x] vmclock for auto-generating cuckoo sandbox VMs 
- [x] VMWare -auto installation w/o user interaction 
- [x] md5sum samples 
- [x] host ssh-agent forwarding to clone vmcloak repo code 
- [ ] QEMU source code compilation + patching, KVM, libvirt apparmor config
