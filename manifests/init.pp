class centos_hostname (
	$hname='localhost'
) {
	case $::operatingsystem {
		'CentOS': {
			host {$hname:ip =>'127.0.0.1',host_aliases=>['localhost','localhost.localdomain','localhost4','localhost4.localdomain4']}
			host {'localhost':ip =>'127.0.0.1',ensure=>'absent'}
			host {'localhost6':ip =>'::1',host_aliases=>['localhost','localhost.localdomain','localhost6.localdomain6']}
		}
	}
}