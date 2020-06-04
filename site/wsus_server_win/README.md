# wsus_server_win

This module installs [WSUS](https://docs.microsoft.com/en-us/windows-server/administration/windows-server-update-services/get-started/windows-server-update-services-wsus#wsus-server-role-description) and configures [IIS](https://support.microsoft.com/en-us/help/4490414/windows-server-update-services-best-practices) for use with WSUS.

## Description

This module will install WSUS and pre-configure IIS so that the systems can either become an upstream or downstream WSUS server.

## Parameters

### WSUS

* ``` wsus_directory ``` - The location to install WSUS (e.g. `d:/wsus_dir`). Defaults to `undef`.
* ``` wsus_features ``` - WSUS features to be installed. Defaults to `UpdateServices`, `UpdateServices-Services`, `UpdateServices-RSAT`, `UpdateServices-API`, and `UpdateServices-UI`.

### IIS

Additional info on IIS Application Pools can be found [here](https://docs.microsoft.com/en-us/iis/configuration/system.applicationhost/applicationpools/add/processmodel#configuration).

* ``` iis_features ``` - IIS features to be installed. Defaults to `Web-WebServer`, `Web-Mgmt-Tools`, and `Web-Mgmt-Console`.
* ``` iis_wsus_app_pool_identity_type ``` - The WSUS IIS application pool identity type. Defaults to `NetworkService`.
* ``` iis_wsus_app_pool_idle_timeout ``` - The WSUS IIS application pool idle timeout. Defaults to `00:00:00`.
* ``` iis_wsus_app_pool_pinging_enabled ``` - The WSUS IIS application pool pinging enabled setting. Defaults to `false`.
* ``` iis_wsus_app_pool_private_memory ``` - The WSUS IIS application pool private memory limit. Defaults to `0`.
* ``` iis_wsus_app_pool_queue_length ``` - The WSUS IIS application pool queue length. Defaults to `2000`.
* ``` iis_wsus_app_pool_restart_time_limit ``` - The WSUS IIS application pool restart time limit. Defaults to `00:00:00`.

## Usage

At a minimum specify `wsus_directory`.

## Example

To override a default simply supply the parameter.

```ruby
class { 'wsus_server_win':
  wsus_directory                    => 'd:/wsus_dir',
  iis_wsus_app_pool_pinging_enabled => true,
}
```
