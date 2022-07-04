# Setup Puppet Certs

The Nautilus DevOps team has set up a puppet master and an agent node in Stratos Datacenter. Puppet master is running on jump host itself (also note that Puppet master node is also running as Puppet CA server) and Puppet agent is running on App Server 2. Since it is a fresh set up, the team wants to sign certificates for puppet master as well as puppet agent nodes so that they can proceed with the next steps of set up. You can find more details about the task below:  
Puppet server and agent nodes are already have required packages, but you may need to start puppetserver (on master) and puppet service on both nodes.  
Assign and sign certificates for both master and agent node.  


## 1. On jump_host and stapp01 add word "puppet" at the end of the hostnames
`sudo -i`  
`vi /etc/hosts`
```bash
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01.stratos.xfusioncorp.com
172.16.238.11   stapp02.stratos.xfusioncorp.com
172.16.238.12   stapp03.stratos.xfusioncorp.com
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host puppet
172.16.239.4    jump_host.stratos.xfusioncorp.com jump_host puppet
172.17.0.5      jump_host.stratos.xfusioncorp.com jump_host puppet
```

`ssh steve@172.16.238.11`  
`sudo -i`  
`vi /etc/hosts`
```bash
<...>
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host puppet
172.16.239.4    jump_host.stratos.xfusioncorp.com jump_host puppet
172.17.0.5      jump_host.stratos.xfusioncorp.com jump_host puppet
```


## 2. restart the services 
### 2.1. on master node:
`systemctl restart puppetserver`  
`systemctl start puppet`
`systemctl status puppetserver`
```bash
● puppetserver.service - puppetserver Service
   Loaded: loaded (/usr/lib/systemd/system/puppetserver.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-07-04 07:26:43 UTC; 1min 39s ago
  Process: 13905 ExecStop=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver stop (code=exited, status=0/SUCCESS)
  Process: 14096 ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start (code=exited, status=0/SUCCESS)
 Main PID: 14157 (java)
    Tasks: 92 (limit: 4915)
   CGroup: /docker/5302358a81734c43b22c9a74ad95c11feccde2b2c4d91c91c1ed602c5e20925e/system.slice/puppetserver.service
           └─14157 /usr/bin/java -Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger -XX:OnOutOfMemoryError="kill -9 %p" -XX:ErrorFile=/var/log/puppetlabs...
```

`systemctl status puppet`
```bash
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-07-04 07:28:19 UTC; 19s ago
 Main PID: 14599 (puppet)
    Tasks: 2
   CGroup: /docker/5302358a81734c43b22c9a74ad95c11feccde2b2c4d91c91c1ed602c5e20925e/system.slice/puppet.service
           └─14599 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Jul 04 07:28:21 jump_host.stratos.xfusioncorp.com puppet-agent[14599]: Starting Puppet client version 6.24.0
Jul 04 07:28:28 jump_host.stratos.xfusioncorp.com puppet-agent[14615]: Applied catalog in 0.01 seconds
```


### and on stapp02:
`sudo systemctl start puppet`  

`sudo systemctl status puppet`
```bash
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-07-04 07:17:15 UTC; 11min ago
 Main PID: 487 (puppet)
   CGroup: /docker/9aacc30ad2676f118a9a89a41929a8a08d2da3cd2acd9a620740e21207502f4a/system.slice/puppet.service
           └─487 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Jul 04 07:20:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: No more routes to ca
Jul 04 07:24:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: Request to https://puppet:8140/puppet-ca/v1 timed out connect operation after 120.001 seconds
Jul 04 07:24:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: Wrapped exception:
Jul 04 07:24:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: execution expired
Jul 04 07:24:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: No more routes to ca
Jul 04 07:28:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: Request to https://puppet:8140/puppet-ca/v1 timed out connect operation after 120.183 seconds
Jul 04 07:28:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: Wrapped exception:
Jul 04 07:28:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: execution expired
Jul 04 07:28:05 stapp02.stratos.xfusioncorp.com puppet-agent[487]: No more routes to ca
Jul 04 07:29:08 stapp02.stratos.xfusioncorp.com systemd[1]: Trying to enqueue job puppet.service/start/replace
```


## 3. On stapp02:
`puppet agent -t`  
```bash
Info: Creating a new RSA SSL key for stapp02.stratos.xfusioncorp.com
Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for stapp02.stratos.xfusioncorp.com
Info: Certificate Request fingerprint (SHA256): FE:42:31:22:AA:19:C9:B5:6D:18:BD:F0:9F:F5:84:40:C7:8E:C3:34:31:55:90:A1:5E:23:41:0E:37:D9:C1:DE
Info: Certificate for stapp02.stratos.xfusioncorp.com has not been signed yet
Couldn't fetch certificate from CA server; you might still need to sign this agent's certificate (stapp02.stratos.xfusioncorp.com).
Exiting now because the waitforcert setting is set to 0.
```


## On master node:
`puppetserver ca list --all`  
```bash
Requested Certificates:
    stapp02.stratos.xfusioncorp.com       (SHA256)  FE:42:31:22:AA:19:C9:B5:6D:18:BD:F0:9F:F5:84:40:C7:8E:C3:34:31:55:90:A1:5E:23:41:0E:37:D9:C1:DE
Signed Certificates:
    964369dd618d.c.argo-prod-us-east1.internal       (SHA256)  8C:19:47:FD:59:97:CE:0C:1D:DF:52:92:A3:BA:41:22:F2:3D:95:D4:38:D9:EF:85:65:9A:7B:B5:59:D5:CA:E6  alt names: ["DNS:puppet", "DNS:964369dd618d.c.argo-prod-us-east1.internal"]  authorization extensions: [pp_cli_auth: true]
    jump_host.stratos.xfusioncorp.com                (SHA256)  52:C9:F3:B2:5B:6C:81:A5:2D:57:95:17:1D:CD:25:CD:6B:5E:F0:83:B2:A5:97:A4:EB:1A:35:A4:26:D1:2F:D0  alt names: ["DNS:puppet", "DNS:jump_host.stratos.xfusioncorp.com"]   authorization extensions: [pp_cli_auth: true]
```

`puppetserver ca sign --all`  
```bash
Successfully signed certificate request for stapp02.stratos.xfusioncorp.com
```


## 4. Validate on stapp02:
`sudo systemctl restart puppet`  
```bash
sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-07-04 07:30:35 UTC; 2s ago
 Main PID: 692 (puppet)
   CGroup: /docker/9aacc30ad2676f118a9a89a41929a8a08d2da3cd2acd9a620740e21207502f4a/system.slice/puppet.service
           └─692 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: Stopped Puppet agent.
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: Converting job puppet.service/restart -> puppet.service/start
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: puppet.service: cgroup is empty
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: About to execute: /opt/puppetlabs/puppet/bin/puppet agent $PUPPET_EXTRA_OPTS --no-daemonize
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: Forked /opt/puppetlabs/puppet/bin/puppet as 692
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: puppet.service changed dead -> running
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: Job puppet.service/start finished, result=done
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[1]: Started Puppet agent.
Jul 04 07:30:35 stapp02.stratos.xfusioncorp.com systemd[692]: Executing: /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
```


```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c1e840cf0d3fde41cb874b
```
