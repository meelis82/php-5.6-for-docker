class build::php56::extensions::blackfire {
  require build::php56

  bash_exec { 'mkdir -p /var/run/blackfire': }

  file { '/usr/local/src/phpfarm/inst/php-5.6.40/lib/php/extensions/no-debug-non-zts-20131226/blackfire-php-linux_amd64-php-56.so':
    ensure => present,
    source => 'puppet:///modules/build/tmp/blackfire-php-linux_amd64-php-56.so'
  }

  bash_exec { 'curl -s https://packagecloud.io/gpg.key | apt-key add -': }

  file { '/etc/apt/sources.list.d/blackfire.list':
    ensure => present,
    source => 'puppet:///modules/build/etc/apt/sources.list.d/blackfire.list',
    mode => 644,
    require => Bash_exec['curl -s https://packagecloud.io/gpg.key | apt-key add -']
  }

  bash_exec { 'apt-get update':
    require => File['/etc/apt/sources.list.d/blackfire.list']
  }

  package {[
      'blackfire-agent'
    ]:
    ensure => present,
    require => Bash_exec['apt-get update']
  }
}
