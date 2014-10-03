class kerberos::params {
  $realm = 'EXAMPLE.COM'
  $kdc = 'kdc.example.com'
  $kdc_provider = 'mit'
  $admin_server = false
  $kinit = false

  case $operatingsystem {
    centos, redhat: { 
      $client_package = 'krb5-workstation'
    }
    default: { 
      $client_package = 'krb5-user'
    }
  }
}
