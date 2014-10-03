# Smartsheet Kerberos Module
Handles Kerberos configuration. Currently supports configuring `krb5.conf` and creating keytabs from an Active Directory KDC.

## Example Usage
```puppet
class { kerberos:
  realm         => 'EXAMLPE.COM',
  kdc           => 'kdc.example.com',
  kdc_provider  => 'active_directory',
  kinit         => "echo 'passwordfromhiera' | /usr/bin/kinit puppetmaster",
}

kerberos::keytab { '/root/test.keytab':
  prinicpals => ['HTTP/test.example.com'],
  owner      => 'root',
  group      => 'root',
  mode       => 644,
  ldap_base  => 'OU=PuppetNodes',
}
```

# ActiveDirectory Requirements
a User "puppetmaster". recommended to be a ServiceAccount
an OU "PuppetNodes".
the user "puppetmaster" needs the following permissions on OU "PuppetNodes":
  Read
  Create Computer Objects
  Descendent Computer Objects => Reset Password
  Descendent Computer Objects => Write All Properties
  Descendent Computer Objects => Validated Write to Service Principal Name
