# == Class: profile::iis_install
class profile::iis_install (
) {

$iis_features = ['IIS-WebServerRole','IIS-WebServer','IIS-CommonHttpFeatures','IIS-StaticContent','IIS-DefaultDocument','IIS-DirectoryBrowsing','IIS-HttpErrors','IIS-HttpRedirect','IIS-ApplicationDevelopment','IIS-ASPNET','IIS-ServerSideIncludes','IIS-HealthAndDiagnostics','IIS-HttpLogging','IIS-RequestMonitor','IIS-Security','IIS-BasicAuthentication','IIS-WindowsAuthentication','IIS-RequestFiltering','IIS-Performance','IIS-HttpCompressionStatic','IIS-HttpCompressionDynamic','IIS-WebServerManagementTools','IIS-ManagementService']

iis_feature { $iis_features:
  ensure => 'present',
}