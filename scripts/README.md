## Helper Scripts

#### Cisco Issue

When using the Cisco Anyconnect VPN client it blocks out all IP to IP communitication.
The fix for this is to remove this one line from Mac's IP Firewall. This can be solve by:

```sh
./scripts/cisco.workaround.sh
```

