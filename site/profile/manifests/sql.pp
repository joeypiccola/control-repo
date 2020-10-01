# == Class: profile::sql
class profile::sql {

  $instance_name = 'MSSQLSERVER'
  $source_iso_url = 'http://nuget.ad.piccola.us:8081/SQLServer2019-x64-ENU-Dev.iso'
  $source_iso_download_dir = 'F:/install_media'
  $source_iso_mount_drive_letter = 'G'
  $soruce_iso_file = basename($source_iso_url) #SQLServer2019-x64-ENU-Dev.iso
  $source_iso_file_path = "${source_iso_download_dir}/${soruce_iso_file}" # d:/install_media/SQLServer2019-x64-ENU-Dev.iso

  file { 'create_source_iso_download_dir':
    ensure => 'directory',
    path   => $source_iso_download_dir,
  }

  file { 'download_source_iso':
    ensure  => 'present',
    source  => $source_iso_url,
    path    => $source_iso_file_path,
    require => File['create_source_iso_download_dir'],
  }

  mount_iso { 'mount_source_iso':
    source       => $source_iso_file_path,
    drive_letter => $source_iso_mount_drive_letter,
    require      => File['download_source_iso'],
  }

  #sqlserver_instance { 'install_instance':
  #  name                  => $instance_name,
  #  source                => $source_iso_mount_drive_letter,
  #  features              => ['SQLEngine'],
  #  sql_sysadmin_accounts => [$facts['id']],
  #  install_switches      => {
  #    'TCPENABLED'          => 1,
  #    'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
  #    'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
  #    'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
  #    'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
  #    'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
  #    'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server'
  #  },
  #  require               => Mount_iso[mount_source_iso],
  #}


}
