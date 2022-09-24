# Setup Puppet Certs Autosign

During last weekly meeting, the Nautilus DevOps team has decided to use Puppet autosign config to auto sign the certificates for all Puppet agent nodes that they will keep adding under the Puppet master in Stratos DC. The Puppet master and CA servers are currently running on jump host and all three app servers are configured as Puppet agents. To set up autosign configuration on the Puppet master server, some configuration settings must be done. Please find below more details:  
The Puppet server package is already installed on puppet master i.e jump server and the Puppet agent package is already installed on all App Servers. However, you may need to start the required services on all of these servers.  
Configure autosign configuration on the Puppet master i.e jump server (by creating an autosign.conf in the puppet configuration directory) and assign the certificates for master node as well as for the all agent nodes. Use the respective host's FDQN to assign the certificates.  
Use alias puppet (dns_alt_names) for master node and add its entry in /etc/hosts config file on master i.e Jump Server as well as on the all agent nodes i.e App Servers.  
Notes:  
- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.
- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.
- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.




## 1. Reconnaissance on the puppet server
`sudo -i`  
`cat /etc/hosts`  
```console
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01.stratos.xfusioncorp.com
172.16.238.11   stapp02.stratos.xfusioncorp.com
172.16.238.12   stapp03.stratos.xfusioncorp.com
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host
172.16.239.3    jump_host.stratos.xfusioncorp.com jump_host
172.17.0.6      jump_host.stratos.xfusioncorp.com jump_host
```

`ping puppet`  
```console
PING puppet.stratos.xfusioncorp.com (216.245.213.76) 56(84) bytes of data.
64 bytes from 76-213-245-216.static.reverse.lstn.net (216.245.213.76): icmp_seq=3 ttl=57 time=16.0 ms
64 bytes from 76-213-245-216.static.reverse.lstn.net (216.245.213.76): icmp_seq=4 ttl=57 time=15.4 ms
64 bytes from 76-213-245-216.static.reverse.lstn.net (216.245.213.76): icmp_seq=5 ttl=57 time=15.4 ms
^C
--- puppet.stratos.xfusioncorp.com ping statistics ---
5 packets transmitted, 3 received, 40% packet loss, time 4054ms
rtt min/avg/max/mdev = 15.440/15.671/16.096/0.300 ms
```

## 2. Add the alias for the puppet server
`vi /etc/hosts`  
```console
...
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host **puppet**
...
```

`ping puppet`  
```console
PING jump_host.stratos.xfusioncorp.com (172.16.238.3) 56(84) bytes of data.
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=1 ttl=64 time=0.027 ms
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=2 ttl=64 time=0.031 ms
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=3 ttl=64 time=0.035 ms
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=4 ttl=64 time=0.034 ms
^C
--- jump_host.stratos.xfusioncorp.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3058ms
rtt min/avg/max/mdev = 0.027/0.031/0.035/0.007 ms
```


## 3. Create autosign config
`vi /etc/puppetlabs/puppet/autosign.conf`  
```console
jump_host.stratos.xfusioncorp.com
stapp01.stratos.xfusioncorp.com
stapp02.stratos.xfusioncorp.com
stapp03.stratos.xfusioncorp.com
```


## 4. Restart the puppet daemon
`systemctl status puppetserver`  
```console
● puppetserver.service - puppetserver Service
   Loaded: loaded (/usr/lib/systemd/system/puppetserver.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-09-24 16:46:54 UTC; 6min ago
  Process: 13135 ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start (code=exited, status=0/SUCCESS)
 Main PID: 13198 (java)
    Tasks: 91 (limit: 4915)
   CGroup: /docker/4fdcc0c01e6bc19d92e7c3abfd9c5a03e5d4681a29ec0693a0a45cdac88027dd/system.slice/puppetserver.service
           └─13198 /usr/bin/java -Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger -XX:OnOutOfMemoryError="kill -9 %p" -XX:ErrorFile=/var/log/puppetlabs...
```

`systemctl restart puppetserver`  
`systemctl status puppetserver`  
```console
● puppetserver.service - puppetserver Service
   Loaded: loaded (/usr/lib/systemd/system/puppetserver.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-09-24 16:55:32 UTC; 28s ago
  Process: 13734 ExecStop=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver stop (code=exited, status=0/SUCCESS)
  Process: 13924 ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start (code=exited, status=0/SUCCESS)
 Main PID: 13985 (java)
    Tasks: 89 (limit: 4915)
   CGroup: /docker/4fdcc0c01e6bc19d92e7c3abfd9c5a03e5d4681a29ec0693a0a45cdac88027dd/system.slice/puppetserver.service
           └─13985 /usr/bin/java -Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger -XX:OnOutOfMemoryError="kill -9 %p" -XX:ErrorFile=/var/log/puppetlabs...
```


## 5. Check certificates on puppet server
`puppetserver ca list --all`  
```console
Signed Certificates:
    964369dd618d.c.argo-prod-us-east1.internal       (SHA256)  8C:19:47:FD:59:97:CE:0C:1D:DF:52:92:A3:BA:41:22:F2:3D:95:D4:38:D9:EF:85:65:9A:7B:B5:59:D5:CA:E6  alt names: ["DNS:puppet", "DNS:964369dd618d.c.argo-prod-us-east1.internal"]  authorization extensions: [pp_cli_auth: true]
```


## 6-8. Login on stapp01, stapp02, stapp03 and run the same commands
`ssh tony@stapp01`  
`sudo -i`  
`vi /etc/hosts`  
```console
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.3    jump_host.stratos.xfusioncorp.com puppet
172.16.239.2    stapp03.stratos.xfusioncorp.com stapp03
172.16.238.12   stapp03.stratos.xfusioncorp.com stapp03
172.17.0.4      stapp03.stratos.xfusioncorp.com stapp03
```

`ping puppet`  
```console
PING jump_host.stratos.xfusioncorp.com (172.16.238.3) 56(84) bytes of data.
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=1 ttl=64 time=0.044 ms
64 bytes from jump_host.stratos.xfusioncorp.com (172.16.238.3): icmp_seq=2 ttl=64 time=0.066 ms
^C
--- jump_host.stratos.xfusioncorp.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1006ms
rtt min/avg/max/mdev = 0.044/0.055/0.066/0.011 ms
```

`systemctl restart puppet`  
`systemctl status puppet`  
```console
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-09-24 17:05:37 UTC; 12s ago
 Main PID: 503 (puppet)
   CGroup: /docker/67e282933905f5bddfb0430cb1bb551d3114d56f999790aae4d0cf6be54f40b0/system.slice/puppet.service
           └─503 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Sep 24 17:05:37 stapp01.stratos.xfusioncorp.com systemd[1]: puppet.service changed dead -> running
Sep 24 17:05:37 stapp01.stratos.xfusioncorp.com systemd[1]: Job puppet.service/start finished, result=done
Sep 24 17:05:37 stapp01.stratos.xfusioncorp.com systemd[1]: Started Puppet agent.
Sep 24 17:05:37 stapp01.stratos.xfusioncorp.com systemd[503]: Executing: /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
Sep 24 17:05:38 stapp01.stratos.xfusioncorp.com puppet-agent[503]: Starting Puppet client version 6.15.0
Sep 24 17:05:40 stapp01.stratos.xfusioncorp.com puppet-agent[520]: Applied catalog in 0.01 seconds
```

`puppet agent -tv`  
```console
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1664039177'
Notice: Applied catalog in 0.01 seconds
```


## 9. List certificates on puppet server
`puppetserver ca list --all`  
```console
Signed Certificates:
    964369dd618d.c.argo-prod-us-east1.internal       (SHA256)  8C:19:47:FD:59:97:CE:0C:1D:DF:52:92:A3:BA:41:22:F2:3D:95:D4:38:D9:EF:85:65:9A:7B:B5:59:D5:CA:E6  alt names: ["DNS:puppet", "DNS:964369dd618d.c.argo-prod-us-east1.internal"]  authorization extensions: [pp_cli_auth: true]
    jump_host.stratos.xfusioncorp.com                (SHA256)  D9:E4:7C:05:1B:F7:E4:05:E2:B3:86:BE:D8:A7:F9:A6:A9:2A:8A:5C:EC:27:98:E3:5B:C3:EA:44:4E:E0:7D:D7  alt names: ["DNS:puppet", "DNS:jump_host.stratos.xfusioncorp.com"]   authorization extensions: [pp_cli_auth: true]
    stapp01.stratos.xfusioncorp.com                  (SHA256)  0D:F5:43:28:F3:A5:95:EE:6D:3C:FF:3A:BF:FA:90:6E:78:EE:2B:C6:4F:98:98:7D:9A:D1:C2:70:43:CD:E4:70  alt names: ["DNS:stapp01.stratos.xfusioncorp.com"]
    stapp02.stratos.xfusioncorp.com                  (SHA256)  42:B9:4A:47:A3:64:8B:90:D7:70:BD:29:36:FC:9B:C0:B2:8F:6E:5F:4F:17:01:5D:02:0F:C2:2D:18:A4:E6:4B  alt names: ["DNS:stapp02.stratos.xfusioncorp.com"]
    stapp03.stratos.xfusioncorp.com                  (SHA256)  0F:32:70:18:A1:05:1C:44:6B:8D:75:28:8D:36:07:FC:83:66:C4:33:57:AA:EB:D4:0D:EF:04:53:40:6A:C7:10  alt names: ["DNS:stapp03.stratos.xfusioncorp.com"]
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:632ee3ecaea2997527f83de1
```
