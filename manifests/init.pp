class hanlon (
  $install_dir = '/opt/hanlon',
  $source_url  = 'https://github.com/csc/Hanlon.git',
  $source_rev  = 'v1.1.0',
  $listenaddr  = $::ipaddress,
  $image_path  = '/opt/hanlon/image',
  $dbtype      = 'mongo',
  $dbhost      = '127.0.0.1',
  $dbport      = '27017',
  $dbuser      = '',
  $dbpwd       = '',
){

  ensure_packages(['git-core', 'ruby', 'rubygems', 'ruby1.9.1-dev', 'libssl-dev', 'bundler'])

  vcsrepo { "${install_dir}":
    ensure   => present,
    provider => 'git',
    source   => $source_url,
    revision => $source_rev,
  }

  exec { 'install hanlon':
    command => 'bundle install',
    cwd     => $install_dir,
    unless  => 'bundle check',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    timeout => 0,
  }

  file { '/etc/hanlon':
    ensure => directory,
  }

  file { '/etc/hanlon/client.conf':
    ensure  => file,
    content => template('hanlon/hanlon_client.conf'),
  }

  file { '/etc/hanlon/server.conf':
    ensure  => file,
    content => template('hanlon/hanlon_server.conf'),
  }

  file { "${install_dir}/cli/conf":
    ensure => directory,
  }

  file { "${install_dir}/cli/conf/hanlon_client.conf":
    ensure  => link,
    target  => '/etc/hanlon/client.conf',
    require => File['/etc/hanlon/client.conf'],
  }

  file { "${install_dir}/web/config":
    ensure  => directory,
  }

  file { "${install_dir}/web/config/hanlon_server.conf":
    ensure  => link,
    target  => '/etc/hanlon/server.conf',
    require => File['/etc/hanlon/server.conf'],
  }

}