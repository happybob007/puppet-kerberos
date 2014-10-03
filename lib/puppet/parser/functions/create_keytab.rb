module Puppet::Parser::Functions
  newfunction(:create_keytab, :type => :rvalue) do |args|
    # Prepare the arguments for msktutil.
    principals = args[0]
    principals_args = " -s #{principals.join(' -s ')}"
    
    main_principal_bits = principals[0].split('.', 2)[0].split('/')

    if args[3]
      account_name = args[3]
    else
      account_name = "#{main_principal_bits[1]}_#{main_principal_bits[0]}"
    end
    account_name_arg = " --account-name #{account_name}"

    ldap_base_arg = " --base \"#{args[1]}\""

    # Create the keytab directory if it doesn't exist.
    unless File.exists?('/var/lib/puppet/kerberos')
      Dir.mkdir('/var/lib/puppet/kerberos', 0700)
    end

    keytab_filename = "/var/lib/puppet/kerberos/#{account_name}.keytab"

    unless File.exists?(keytab_filename)
      # The keytab doesn't exist, create it.

      # Authenticate with the KDC.
      kinit = args[2]
      if !system(kinit)
        raise Puppet::ParseError, 'Failed to authenticate with the KDC'
      end

      # Create the keytab.
      if !system("msktutil --user-creds-only -u #{principals_args}#{account_name_arg}#{ldap_base_arg} -k #{keytab_filename} -N")
        raise Puppet::ParseError, 'An error occurred while creating a keytab'
      end
    end

    # Open the keytab file and return the contents.
    keytab = File.open(keytab_filename)
    keytab_contents = keytab.read
    keytab.close
    keytab_contents
  end
end
