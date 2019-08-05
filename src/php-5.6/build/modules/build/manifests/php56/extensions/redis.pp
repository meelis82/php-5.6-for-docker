class build::php56::extensions::redis {
  require build::php56
  require build::php56::extensions::igbinary

  file { '/tmp/redis-2.2.5.tgz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/redis-2.2.5.tgz'
  }

  bash_exec { 'cd /tmp && tar xzf redis-2.2.5.tgz':
    require => File['/tmp/redis-2.2.5.tgz']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && phpize-5.6.40':
    require => Bash_exec['cd /tmp && tar xzf redis-2.2.5.tgz']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.6.40 --enable-redis-igbinary':
    timeout => 0,
    require => Bash_exec['cd /tmp/redis-2.2.5 && phpize-5.6.40']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/redis-2.2.5 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.6.40 --enable-redis-igbinary']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/redis-2.2.5 && make']
  }
}
