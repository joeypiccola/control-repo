# == Class: profile::sql
class profile::sql {

  $instance_name                 = 'SHRD01'
  $source_iso_url                = 'http://nuget.ad.piccola.us:8081/SQLServer2019-x64-ENU-Dev.iso'
  $source_iso_download_dir       = 'F:/install_media'
  $source_iso_extracted_dir      = 'F:/install_media/extracted'
  $source_iso_mount_drive_letter = 'G'
  $soruce_iso_file_name          = basename($source_iso_url) # SQLServer2019-x64-ENU-Dev.iso
  $source_iso_file_path          = "${source_iso_download_dir}/${soruce_iso_file_name}" # d:/install_media/SQLServer2019-x64-ENU-Dev.iso

  file { 'create_source_iso_download_dir':
    ensure => 'directory',
    path   => $source_iso_download_dir,
  }

  file { 'create_source_iso_extracted_dir':
    ensure => 'directory',
    path   => $source_iso_extracted_dir,
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

  file { 'copy_source_iso_contents':
    source => "${source_iso_mount_drive_letter}:/",
    path   => $source_iso_extracted_dir,
  }

  # sqlserver_instance { 'install_instance':
  #   name                  => $instance_name,
  #   source                => "${source_iso_mount_drive_letter}:/",
  #   features              => ['SQL'],
  #   sql_sysadmin_accounts => [$facts['id']],
  #   install_switches      => {
  #     'TCPENABLED'          => 1,
  #     'SQLBACKUPDIR'        => "F:\\instances\\${instance_name}\\Backup",
  #     'SQLTEMPDBDIR'        => "F:\\instances\\${instance_name}\\TempDb",
  #     'INSTALLSQLDATADIR'   => "F:\\instances\\${instance_name}",
  #     'INSTANCEDIR'         => 'F:\\Program Files\\Microsoft SQL Server',
  #     'INSTALLSHAREDDIR'    => 'F:\\Program Files\\Microsoft SQL Server',
  #     'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
  #   },
  #   require               => Mount_iso[mount_source_iso],
  # }


}
