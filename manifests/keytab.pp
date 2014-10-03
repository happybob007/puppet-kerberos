define kerberos::keytab (
  $prinicpals   = [],
  $owner,
  $group,
  $mode         = 600,
  $account_name = false,
  $ldap_base    = false,
) {
  include kerberos

  $kdc_provider = $kerberos::kdc_provider
  if $kdc_provider != 'active_directory' {
    fail('Currently only Active Directory KDCs are supported.')
  }

  if $title {
    $keytab_file = $title
    $keytab_file_argument = " -k ${keytab_file}"
  } else {
    $keytab_file = '/etc/krb5.keytab'
  }

  $kinit = $kerberos::kinit

  file { $keytab_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => create_keytab($prinicpals, $ldap_base, $kinit, $account_name)
  }
}
