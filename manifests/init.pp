class kerberos (
  $realm          = $kerberos::params::realm,
  $kdc            = $kerberos::params::kdc,
  $kdc_provider   = $kerberos::params::kdc_provider,
  $admin_server   = $kerberos::params::admin_server,
  $client_package = $kerberos::params::client_package,
  $kinit          = $kerberos::params::kinit
) inherits kerberos::params {

  unless $::kernel == 'Linux' {
    fail("No support for managing Kerberos on ${::kernel} systems")
  }

  # Set up the Kerberos client.
  package { $client_package:
    ensure => installed,
    alias  => 'krb5-client'
  }

  file { 'krb5.conf':
    ensure  => file,
    path    => '/etc/krb5.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => Package['krb5-client'],
    content => template('kerberos/krb5.conf.erb')
  }

  if $kdc_provider == 'active_directory' {
    package { 'msktutil':
      ensure => installed
    }
  }

}
