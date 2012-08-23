class apt {
		
	# Translate distribution information to match sources.list file
	$aptsourceslist = $lsbdistdescription ? {
		"Ubuntu 10.04.4 LTS" => "sources.list-10.04",
		"Ubuntu 11.10"   => "sources.list-11.10",
		"Ubuntu 12.04 LTS"   => "sources.list-12.04",
		default  => 'none',
	  }	
	  
	file { 
	"apt-sources-list":
		ensure	=> file,
		path 	=> '/etc/apt/sources.list',
		mode   	=> "0644",
		owner	=> 'root',
		group	=> 'root',
		source	=> "puppet:///modules/apt/${$aptsourceslist}",
		notify	=> Exec['apt-get-update'];
			
	}
	
	exec {
	"apt-get-update":
	    command	=> "/usr/bin/sudo apt-get update",	
	    onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
	    timeout => 720,
	}
}
