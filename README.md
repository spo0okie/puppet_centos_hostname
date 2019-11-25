# puppet_centos_hostname
Управление hostname'ом в идеологии Centos

управляет содержимым /etc/hosts, чтобы привести его к виду
```
127.0.0.1   hostname.domain.local  localhost localhost.localdomain localhost4 localhost4.localdomain4
::1 localhost6  localhost localhost.localdomain localhost6.localdomain6
```
потомучто это решает, что вернет hostname -f

Прочитал в интернетах (https://unix.stackexchange.com/questions/158877/linux-hostname-f-command-is-not-working-on-rhel) такую инфу:  
The hostname command returns results from DNS and /etc/hosts.  

hostname is equivilant to uname -n and is the actual "hostname" or "nodename" of the box.  
All the other hostname arguments use this nodename to look up info.  
  
So before going any further, I should explain the /etc/hosts file format.  
The first field is fairly obvious, its the IP address all the hostnames on the line should resolve to. The second field is the primary hostname for that IP. The remaining fields are aliases.  
  
So if you run hostname -f it will first try to resolve the IP for your nodename. Depending on how you have the hosts: entry configured in /etc/nsswitch.conf this method will vary.  
  
* If you have it configured to use dns, it will use the search domains configured in /etc/resolv.conf until it gets an IP back from DNS.
* If you have it configured to use files it will look in /etc/hosts to find a line where either the primary hostname or the alias name is your current nodename (uname -n), and then return the IP address in that line.  
Once it has the IP it will then try a reverse lookup on that IP. Again it will use DNS for this and your hosts file based on your nsswitch.conf. In the case of using your hosts file, it will return the primary entry (which is the first field after the IP in the file).  

hostname -a will only work with the hosts file since doing a reverse lookup in DNS only gives you 1 result. With the hosts file it return the alises in the matching line (which is everything after the first entry, the primary hostname).  

So in short, the likely reason for your issue is that you have no entry in /etc/hosts that contains your hostname (uname -n).

--- 
Examples
If your nodename is 'foobar', and you have an entry in /etc/hosts such as this:

127.0.0.1 foobar.example.com foobar localhost.localdomain localhost
Then you will get the following command results:
```
# hostname
foobar
# uname -n
foobar

# hostname -f
foobar.example.com

# hostname -a
foobar localhost.localdomain localhost
```
