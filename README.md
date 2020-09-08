# satellite_rhcos_pxe
Scripts and tools to configure Red Hat Satellite to PXE boot Red Hat CoreOS Nodes

## Setup

- Copy the env.sh.example file to env.sh and file in the variable file

# Enable BMC for controlling bare metal hosts

- If intending to use Satellite to control the physical host's power make sure BMC is enabled.
- To enable BMC running the following command on the satellite server

```
satellite-installer --foreman-proxy-bmc=true --foreman-proxy-bmc-default-provider=ipmitool
```

# Configure Satellite to enable TFTP server

- Run the following command on the satellite server to enable the TFTP server

```
satellite-installer --foreman-proxy-tftp true --foreman-proxy-tftp-servername $(hostname)
```

- Note: In my tests the tftp daemon did not start after running the above command
- To start the tftp daemon on the Satellite server run the following command

```
systemctl start tftp
```


# Configure Satellite to enable DHCP Server

- Satellite can be the DHCP server or you can configure your own, pointing the next-server to satellite
- Run the following command to enable the DHCP daemon on the satellite server

```
satellite-installer --foreman-proxy-dhcp true \
    --foreman-proxy-dhcp-interface <device name> \
    --foreman-proxy-dhcp-range "xx.xx.xx.xx xx.xx.xx.xx" \
    --foreman-proxy-dhcp-gateway xx.xx.xx.xx \
    --foreman-proxy-dhcp-nameservers xx.xx.xx.xx
```

# Issues

- The PXE linux menus created by Satellite appear to be invalid. There are spaces in the label names. Possibly odd characters.
