class build::php56 {
  require build::php56::packages
  require build::php56::supervisor
  require build::phpfarm
  require build::freetds

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.6.40/etc/conf.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.6.40/etc/fpm.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.6.40/etc/pool.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.6.40/lib/php/extensions/no-debug-non-zts-20131226': }

  file { '/usr/include/curl':
    ensure => link,
    target => '/usr/include/x86_64-linux-gnu/curl',
  }

  file { '/tmp/php-5.6.40.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/php-5.6.40.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf php-5.6.40.tar.gz':
    require => [
        File['/tmp/php-5.6.40.tar.gz'],
        File['/usr/include/curl']
    ]
  }

  bash_exec { 'mv /tmp/php-5.6.40 /usr/local/src/phpfarm/src/php-5.6.40':
    require => Bash_exec['cd /tmp && tar xzf php-5.6.40.tar.gz']
  }

  file { '/usr/local/src/phpfarm/src/custom/options-5.6.40.sh':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/src/custom/options-5.6.40.sh',
    mode => "755",
    require => Bash_exec['mv /tmp/php-5.6.40 /usr/local/src/phpfarm/src/php-5.6.40']
  }

  bash_exec { '/usr/local/src/phpfarm/src/main.sh 5.6.40':
    timeout => 0,
    require => File['/usr/local/src/phpfarm/src/custom/options-5.6.40.sh']
  }

  bash_exec { 'rm -rf /usr/local/src/phpfarm/src/php-5.6.40':
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.6.40']
  }

  file { '/usr/local/src/phpfarm/inst/php-5.6.40/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/php-5.6.40/etc/php-fpm.conf',
    mode => "644",
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.6.40']
  }

  bash_exec { 'switch-phpfarm 5.6.40':
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.6.40']
  }
}
