class run::php56::ini::apd {
  file { '/usr/local/src/phpfarm/inst/current/etc/conf.d/apd.ini':
    ensure => present,
    content => template('run/php56/ini/apd.ini.erb'),
    mode => "644"
  }
}
