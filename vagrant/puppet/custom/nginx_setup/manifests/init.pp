include nginx

class nginx_setup (
  $version = present,
  $manage_package = true,
) {

  if $manage_package {
    if !defined(Package['wget']) {
      if $::kernel == 'Linux' {
        package { 'nginx': ensure => $version }
      }
      elsif $::kernel == 'FreeBSD' {
        if versioncmp($facts['os']['release']['major'], '10') >= 0 {
          package { 'nginx': ensure => $version }
        }
        else {
          package { 'nginx':
            ensure => $version,
            name   => 'ftp/wget',
            alias  => 'nginx';
          }
        }
      }
    }
  }

  $full_web_path = '/var/www'

  define web::nginx_ssl_with_redirect (
    $backend_port         = 9000,
    $php                  = true,
    $proxy                = undef,
    $www_root             = "${full_web_path}/${name}/",
    $location_cfg_append  = undef,
  ) {
    nginx::resource::server { "${name}.${::domain}":
      ensure              => present,
      www_root            => "${full_web_path}/${name}/",
      location_cfg_append => {
        'rewrite' => '^ https://$server_name$request_uri? permanent'
      }‚,
    }

    if !$www_root {
      $tmp_www_root = undef
    } else {
      $tmp_www_root = $www_root
    }

    nginx::resource::server { "${name}.${::domain} ${name}":
      ensure                => present,
      listen_port           => 443,
      www_root              => $tmp_www_root,
      proxy                 => $proxy,
      location_cfg_append   => $location_cfg_append,
      index_files           => [ 'index.php' ],
      ssl                   => true,
      ssl_cert              => '/path/to/wildcard_mydomain.crt',
      ssl_key               => '/path/to/wildcard_mydomain.key',
    }

    if $php {
      nginx::resource::location { "${name}_root":
        ensure          => present,
        ssl             => true,
        ssl_only        => true,
        server           => "${name}.${::domain} ${name}",
        www_root        => "${full_web_path}/${name}/",
        location        => '~ \.php$',
        index_files     => ['index.php', 'index.html', 'index.htm'],
        proxy           => undef,
        fastcgi         => "127.0.0.1:${backend_port}",
        fastcgi_script  => undef,
        location_cfg_append => {
          fastcgi_connect_timeout => '3m',
          fastcgi_read_timeout    => '3m',
          fastcgi_send_timeout    => '3m'
        }
      }
    }
  }

}
