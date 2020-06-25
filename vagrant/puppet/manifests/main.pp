class apt_update {
    exec { "wget":
        command => "wget https://apt.puppetlabs.com/puppet6-release-xenial.deb",
        path => ["/bin", "/usr/bin"]
    }

   exec { "dpkgUpdate":
        command => "sudo dpkg -i puppet6-release-xenial.deb",
        path => ["/bin", "/usr/bin"]
    }

   exec { "puppetInstall":
        command => "aptitude install -y puppet",
        path => ["/bin", "/usr/bin"],
        require => Exec["dpkgUpdate"]
    }

    exec { "aptGetHTTPSTrans":
        command => "sudo apt-get install -y apt-transport-https",
        path => ["/bin", "/usr/bin"],
        require => Exec["puppetInstall"]
    }

    exec { "aptUpdate":
        command => "sudo apt update -y",
        path => ["/bin", "/usr/bin"],
        require => Exec["aptGetHTTPSTrans"]
    }
}

class othertools {
    package { "git":
        ensure => latest,
        require => Exec["aptUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptUpdate"]
    }

    package { "htop":
        ensure => present,
        require => Exec["aptUpdate"]
    }

    package { "g++":
        ensure => present,
        require => Exec["aptUpdate"]
    }
}

include apt_update
include othertools
include stdlib
include mysql
# include nginx
# include postgresql
