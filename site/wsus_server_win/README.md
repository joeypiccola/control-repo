# wsus_server_win

This module installs [WSUS](https://docs.microsoft.com/en-us/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus#wsus-server-role-description) and configures [IIS](https://support.microsoft.com/en-us/help/4490414/windows-server-update-services-best-practices) for use with WSUS.

## Description

WSUS can either be installed to use the Windows Internal Database (WID) or SQL (determined by the paramater `database_type`). In either case `WsusUtil.exe` is required to be run following a successful Puppet run of this module.

## Parameters

### WSUS

* ``` wsus_directory ``` - The location to install WSUS (e.g. `d:/wsus`). Defaults to `undef`.
* ``` database_type ``` - The database type to use, options are `wid` or `sql`. Defaults to `wid`.
* ``` wsus_features ``` - The WSUS features to be installed. Defaults to `UpdateServices-Services`, `UpdateServices-RSAT`, `UpdateServices-API`, and `UpdateServices-UI`.

Note: When specifying `database_type` of either `wid` or `sql` the windows feature `UpdateServices-WidDB` or `UpdateServices-DB` will automatically be installed relative to the `database_type` selected.

### IIS

* ``` iis_features ``` - IIS features to be installed. Defaults to `Web-WebServer`, `Web-Mgmt-Tools`, and `Web-Mgmt-Console`.

### IIS Application Pool

The following define the properties of the `WsusPool` Application Pool.

* ``` iis_wsus_app_pool_identity_type ``` - The WSUS IIS application pool identity type. Defaults to `NetworkService`.
* ``` iis_wsus_app_pool_idle_timeout ``` - The WSUS IIS application pool idle timeout. Defaults to `00:00:00`.
* ``` iis_wsus_app_pool_pinging_enabled ``` - The WSUS IIS application pool pinging enabled setting. Defaults to `false`.
* ``` iis_wsus_app_pool_private_memory ``` - The WSUS IIS application pool private memory limit. Defaults to `0`.
* ``` iis_wsus_app_pool_queue_length ``` - The WSUS IIS application pool queue length. Defaults to `2000`.
* ``` iis_wsus_app_pool_restart_time_limit ``` - The WSUS IIS application pool restart time limit. Defaults to `00:00:00`.

## Usage

At a minimum specify `wsus_directory` and `database_type`.

## Example

To override a default simply supply the parameter.

```ruby
class { 'wsus_server_win':
  database_type  => 'sql',
  wsus_directory => 'd:/wsus',
}
```

## Post Install

`WsusUtil.exe` is required to be run following a successful Puppet run of this module. `WsusUtil.exe` is located in `C:\Program Files\Update Services\Tools\`.

### SQL Server with default instance

```powershell
.\WsusUtil.exe PostInstall SQL_INSTANCE_NAME="sql01.ad.piccola.us" CONTENT_DIR="d:\wsus" MU_ROLLUP=0
```

### SQL Server with named instance

```powershell
.\WsusUtil.exe PostInstall SQL_INSTANCE_NAME="sql01.ad.piccola.us\shrd01" CONTENT_DIR="d:\wsus" MU_ROLLUP=0
```

### WID local to WSUS server

```powershell
.\WsusUtil.exe PostInstall CONTENT_DIR="d:\wsus" MU_ROLLUP=0
```
