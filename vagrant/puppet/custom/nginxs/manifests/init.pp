include nginx

class nginx_setup (
  $version = present,
  $manage_package = true,
) {

  file { "/etc/nginx":
      ensure => "directory",
      source => "puppet:///config/nginx",
      recurse => "remote",
      owner => "root",
      group => "root",
      mode => 755,
  }

  if $manage_package {
    if !defined(Package['wget']) {
      if $::kernel == 'Linux' {
        package { 'nginx': ensure => $version }
      }
    }
  }
}
