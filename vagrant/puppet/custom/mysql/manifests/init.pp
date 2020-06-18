class mysql () {
            
  package { 'mariadb-server':
    ensure  => present,
    before  => [ 
      File['/tmp/mysql_secure_installation.sql'],
      Service['mysql']
    ],
  }
  file { '/etc/my.cnf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mysql/mysql.cnf.erb'),
    notify  => Service['mysql'],
  }
  file { '/root/.my.cnf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/mysql/web_client.cnf',
    notify  => Service['mysql'],
  }
  file { '/tmp/mysql_secure_installation.sql':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/mysql/mysql_secure_installation.sql',
    require => Package[$mariadb_packages],
    before => Exec['mysql_secure_installation'],
  }
  exec { 'mysql_secure_installation':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'mysql -sfu root < /tmp/mysql_secure_installation.sql',
    unless  => 'mysql -uroot -pgudubet',
    require => File['/tmp/mysql_secure_installation.sql'],
  }
  service { 'mysql':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$mariadb_packages],
    subscribe  => [
      File['/etc/my.cnf'],
      File['/root/.my.cnf']
    ],
  }
}