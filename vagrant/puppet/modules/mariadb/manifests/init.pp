class mariadb () {

  exec { "aptGetRepos":
    command => "sudo curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash",
    path => ["/bin", "/usr/bin"],
  }

  exec { "aptGetMaria":
    command => "sudo apt install -y --assume-yes --force-yes mariadb-server galera-4 mariadb-client libmariadb3 mariadb-backup mariadb-common",
    path => ["/bin", "/usr/bin"],
  }

  file { '/tmp/secure_mariadb.sql':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/mariadb/secure_mariadb.sql',
    require => Exec['aptGetMaria'],
  }

  exec { 'secure_mariadb':
    command => template('mariadb/securedb.erb'),
    path => ["/bin", "/usr/bin"],
    logoutput => true
  }
}
