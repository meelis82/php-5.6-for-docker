class build::php56::extensions::ssh2 {
  require build::php56

  file { '/tmp/libssh2-1.9.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/libssh2-1.9.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf libssh2-1.9.0.tar.gz':
    require => File['/tmp/libssh2-1.9.0.tar.gz']
  }

  bash_exec { 'cd /tmp/libssh2-1.9.0 && ./configure':
    timeout => 0,
    require => Bash_exec['cd /tmp && tar xzf libssh2-1.9.0.tar.gz']
  }

  bash_exec { 'cd /tmp/libssh2-1.9.0 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/libssh2-1.9.0 && ./configure']
  }

  bash_exec { 'cd /tmp/libssh2-1.9.0 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/libssh2-1.9.0 && make']
  }


  file { '/tmp/ssh2-0.13.tgz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/ssh2-0.13.tgz',
    require => Bash_exec['cd /tmp/libssh2-1.9.0 && make install']
  }

  bash_exec { 'cd /tmp && tar xzf ssh2-0.13.tgz':
    require => File['/tmp/ssh2-0.13.tgz']
  }

  bash_exec { 'cd /tmp/ssh2-0.13 && phpize-5.6.40':
    require => Bash_exec['cd /tmp && tar xzf ssh2-0.13.tgz']
  }

  bash_exec { 'cd /tmp/ssh2-0.13 && ./configure --with-ssh2':
    timeout => 0,
    require => Bash_exec['cd /tmp/ssh2-0.13 && phpize-5.6.40']
  }

  bash_exec { 'cd /tmp/ssh2-0.13 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/ssh2-0.13 && ./configure --with-ssh2']
  }

  bash_exec { 'cd /tmp/ssh2-0.13 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/ssh2-0.13 && make']
  }

    file { '/usr/local/src/phpfarm/inst/current/etc/conf.d/ssh2.ini':
      ensure => present,
      source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/current/etc/conf.d/ssh2.ini',
      mode => "644",
      require => Bash_exec['cd /tmp/ssh2-0.13 && make install']
    }
}
