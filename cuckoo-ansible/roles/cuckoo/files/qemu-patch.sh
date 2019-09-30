#!/bin/bash

qemu_version=3.1.0

function replace_qemu_clues_public() {
    echo '[+] Patching QEMU clues'
    if ! sed -i 's/QEMU HARDDISK/<WOOT> HARDDISK/g' qemu*/hw/ide/core.c; then
        echo 'QEMU HARDDISK was not replaced in core.c'; fail=1
    fi
    if ! sed -i 's/QEMU HARDDISK/<WOOT> HARDDISK/g' qemu*/hw/scsi/scsi-disk.c; then
        echo 'QEMU HARDDISK was not replaced in scsi-disk.c'; fail=1
    fi
    if ! sed -i 's/QEMU DVD-ROM/<WOOT> DVD-ROM/g' qemu*/hw/ide/core.c; then
        echo 'QEMU DVD-ROM was not replaced in core.c'; fail=1
    fi
    if ! sed -i 's/QEMU DVD-ROM/<WOOT> DVD-ROM/g' qemu*/hw/ide/atapi.c; then
        echo 'QEMU DVD-ROM was not replaced in atapi.c'; fail=1
    fi
    if ! sed -i 's/s->vendor = g_strdup("QEMU");/s->vendor = g_strdup("<WOOT>");/g' qemu*/hw/scsi/scsi-disk.c; then
        echo 'Vendor string was not replaced in scsi-disk.c'; fail=1
    fi
    if ! sed -i 's/QEMU CD-ROM/<WOOT> CD-ROM/g' qemu*/hw/scsi/scsi-disk.c; then
        echo 'QEMU CD-ROM was not patched in scsi-disk.c'; fail=1
    fi
    if ! sed -i 's/padstr8(buf + 8, 8, "QEMU");/padstr8(buf + 8, 8, "<WOOT>");/g' qemu*/hw/ide/atapi.c; then
        echo 'padstr was not replaced in atapi.c'; fail=1
    fi
    if ! sed -i 's/QEMU MICRODRIVE/<WOOT> MICRODRIVE/g' qemu*/hw/ide/core.c; then
        echo 'QEMU MICRODRIVE was not replaced in core.c'; fail=1
    fi
    if ! sed -i 's/KVMKVMKVM\\0\\0\\0/GenuineIntel/g' qemu*/target/i386/kvm.c; then
        echo 'KVMKVMKVM was not replaced in kvm.c'; fail=1
    fi
	# by @http_error_418
    #if  sed -i 's/Microsoft Hv/GenuineIntel/g' qemu*/target/i386/kvm.c; then
    #    echo 'Microsoft Hv was not replaced in target/i386/kvm.c'; fail=1
    #fi
    if ! sed -i 's/"bochs"/"hawks"/g' qemu*/block/bochs.c; then
        echo 'BOCHS was not replaced in block/bochs.c'; fail=1
    fi
    # by Tim Shelton (redsand) @ HAWK (hawk.io)
    if ! sed -i 's/"BOCHS "/"ALASKA"/g' qemu*/include/hw/acpi/aml-build.h; then
        echo 'bochs was not replaced in include/hw/acpi/aml-build.h'; fail=1
    fi
    # by Tim Shelton (redsand) @ HAWK (hawk.io)
    if ! sed -i 's/Bochs Pseudo/Intel RealTime/g' qemu*/roms/ipxe/src/drivers/net/pnic.c; then
        echo 'Bochs Pseudo was not replaced in roms/ipxe/src/drivers/net/pnic.c'; fail=1
    fi
    # by Tim Shelton (redsand) @ HAWK (hawk.io)
    #if ! sed -i 's/Bochs\/Plex86/<WOOT>\/FIRM64/g' qemu*/roms/vgabios/vbe.c; then
    #    echo 'BOCHS was not replaced in roms/vgabios/vbe.c'; fail=1
    #fi
}

function qemu_func() {
    cd /tmp || return

    echo '[+] Cleaning QEMU old install if exists'
    rm -r /usr/share/qemu >/dev/null 2>&1
    dpkg -r ubuntu-vm-builder python-vm-builder >/dev/null 2>&1
    dpkg -l |grep qemu |cut -d " " -f 3|xargs dpkg --purge --force-all >/dev/null 2>&1

    echo '[+] Downloading QEMU source code'
    if [ ! -f qemu-$qemu_version.tar.xz ]; then
        wget "https://download.qemu.org/qemu-$qemu_version.tar.xz"
    fi

    if [ ! -f qemu-$qemu_version.tar.xz ]; then
        echo "[-] Download qemu-$qemu_version failed"
        exit
    fi

    if ! $(tar xf "qemu-$qemu_version.tar.xz") ; then
        echo "[-] Failed to extract, check if download was correct"
        exit 1
    fi
    fail=0

    if [ "$OS" = "Linux" ]; then
        add-apt-repository universe
        apt-get update
        apt-get install acpica-tools intltool checkinstall openbios-* libssh2-1-dev vde2 liblzo2-dev libghc-gtk3-dev libsnappy-dev libbz2-dev libxml2-dev google-perftools libgoogle-perftools-dev libvde-dev -y 2>/dev/null
        apt-get install debhelper ibusb-1.0-0-dev libxen-dev uuid-dev xfslibs-dev libjpeg-dev libusbredirparser-dev device-tree-compiler texinfo libbluetooth-dev libbrlapi-dev libcap-ng-dev libcurl4-gnutls-dev libfdt-dev gnutls-dev libiscsi-dev libncurses5-dev libnuma-dev libcacard-dev librados-dev librbd-dev libsasl2-dev libseccomp-dev libspice-server-dev \
        libaio-dev libcap-dev libattr1-dev libpixman-1-dev libgtk2.0-bin  libxml2-utils systemtap-sdt-dev -y 2>/dev/null
        # libvirt-glib-1.0-0
        apt-get -f -y install

    elif [ "$OS" = "Darwin" ]; then
        _check_brew
        brew install pkg-config libtool jpeg gnutls glib ncurses pixman libpng vde gtk+3 libssh2 libssh2 libvirt snappy libcapn gperftools glib -y
    fi
    # WOOT
    # some checks may be depricated, but keeping them for compatibility with old versions

    if [ $? -eq 0 ]; then
        if declare -f -F "replace_qemu_clues"; then
            replace_qemu_clues
        else
            replace_qemu_clues_public
        fi
        if [ $fail -eq 0 ]; then
            echo '[+] Starting compile it'
            cd qemu-$qemu_version || return
	        # add in future --enable-netmap https://sgros-students.blogspot.com/2016/05/installing-and-testing-netmap.html
            # remove --target-list=i386-softmmu,x86_64-softmmu,i386-linux-user,x86_64-linux-user  if you want all targets
            if [ "$OS" = "Linux" ]; then
                ./configure --prefix=/usr --libexecdir=/usr/lib/qemu --target-list="i386-softmmu x86_64-softmmu" --localstatedir=/var --bindir=/usr/bin/  --enable-gnutls --enable-docs --enable-gtk --enable-vnc --enable-vnc-sasl --enable-vnc-png --enable-vnc-jpeg --enable-curl --enable-kvm  --enable-linux-aio --enable-cap-ng --enable-vhost-net --enable-vhost-crypto --enable-spice --enable-usb-redir --enable-lzo --enable-snappy --enable-bzip2 --enable-coroutine-pool --enable-libssh2 --enable-libxml2 --enable-tcmalloc --enable-replication --enable-tools --enable-capstone
            elif [ "$OS" = "Darwin" ]; then
                # --enable-vhost-net --enable-vhost-crypto
                ./configure --prefix=/usr --libexecdir=/usr/lib/qemu --target-list="i386-softmmu x86_64-softmmu" --localstatedir=/var --bindir=/usr/bin/ --enable-gnutls --enable-docs  --enable-vnc --enable-vnc-sasl --enable-vnc-png --enable-vnc-jpeg --enable-curl --enable-hax --enable-usb-redir --enable-lzo --enable-snappy --enable-bzip2 --enable-coroutine-pool  --enable-libxml2 --enable-tcmalloc --enable-replication --enable-tools --enable-capstone
            fi
            if  [ $? -eq 0 ]; then
                echo '[+] Starting Install it'
                #dpkg -i qemu*.deb
                if [ -f /usr/share/qemu/qemu_logo_no_text.svg ]; then
                    rm /usr/share/qemu/qemu_logo_no_text.svg
                fi
                make -j"$(getconf _NPROCESSORS_ONLN)"
                if [ "$OS" = "Linux" ]; then
                    checkinstall -D --pkgname=qemu-$qemu_version --nodoc --showinstall=no --default
                elif [ "$OS" = "Darwin" ]; then
                    make -j"$(getconf _NPROCESSORS_ONLN)" install
                fi
                # hack for libvirt/virt-manager
                if [ ! -f /usr/bin/qemu-system-x86_64-spice ]; then
                    ln -s /usr/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64-spice
                fi
                if [ ! -f /usr/bin/kvm-spice ]; then
                    ln -s /usr/bin/qemu-system-x86_64 /usr/bin/kvm-spice
                fi
                if [ ! -f /usr/bin/kvm ]; then
                    ln -s /usr/bin/qemu-system-x86_64 /usr/bin/kvm
                fi
                if  [ $? -eq 0 ]; then
                    echo '[+] Patched, compiled and installed'
                else
                    echo '[-] Install failed'
                fi
            else
                echo '[-] Compilling failed'
            fi
        else
            echo '[-] Check previous output'
            exit
        fi

    else
        echo '[-] Download QEMU source was not possible'
    fi
    if [ "$OS" = "linux" ]; then
        dpkg --get-selections | grep "qemu" | xargs apt-mark hold
        dpkg --get-selections | grep "libvirt" | xargs apt-mark hold
        # apt-mark unhold qemu
    fi

}

function usage() {
cat << EndOfHelp
    Usage: $0 <func_name> <args>
    Commands - are case insensitive:
        QEMU - Install QEMU from source
EndOfHelp
}

COMMAND=$(echo "$1"|tr "[A-Z]" "[a-z]")
OS="$(uname -s)"

#check if start with root
if [ "$EUID" -ne 0 ]; then
   echo 'This script must be run as root'
   exit 1
fi

case "$COMMAND" in
'qemu')
    qemu_func;;
'-h')
    usage
    exit 0;;
*)
    usage;;
esac
