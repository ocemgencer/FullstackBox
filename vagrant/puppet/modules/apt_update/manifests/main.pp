class apt_update {
    exec { "wget":
        command => "wget https://apt.puppetlabs.com/puppet6-release-xenial.deb",
        path => ["/bin", "/usr/bin"],
        creates => '/home/vagrant/puppet6-release-xenial.deb'
    }

    exec { "dpkgUpdate":
        command => "sudo dpkg -i puppet6-release-xenial.deb",
        path => ["/bin", "/usr/bin"]
    }

    exec { "puppetInstall":
        command => "sudo apt install -y --assume-yes --force-yes puppet",
        path => ["/bin", "/usr/bin"],
        require => Exec["dpkgUpdate"],
        creates => '/usr/bin/puppet'
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