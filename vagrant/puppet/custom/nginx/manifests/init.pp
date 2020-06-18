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

  }
}
