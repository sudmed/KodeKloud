class apache_installer {
    package {'httpd':
        ensure => installed
    }
}
node 'stapp03.stratos.xfusioncorp.com' {
  include apache_installer
}
