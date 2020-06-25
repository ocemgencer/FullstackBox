class mariadb () {

  exec { "aptGetRepos":
    command => "sudo curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash",
    path => ["/bin", "/usr/bin"],
  }

  exec { "aptGetMaria":
    command => "sudo apt install -y --assume-yes --force-yes mariadb-server galera-4 mariadb-client libmariadb3 mariadb-backup mariadb-common",
    path => ["/bin", "/usr/bin"],
  }

  file { '/tmp/mysql_secure_installation.sql':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/mysql/mysql_secure_installation.sql',
    require => Exec['aptGetMaria'],
  }

  exec { 'secure_mariadb':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'mysql -sfu root < /tmp/mysql_secure_installation.sql',
    unless  => 'mysql -uroot -ppass',
    require => File['/tmp/mysql_secure_installation.sql'],
  }
}