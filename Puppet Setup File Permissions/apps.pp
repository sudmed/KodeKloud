class file_modifier {
   # Update ecommerce.txt under /opt/dba
   file { '/opt/dba/ecommerce.txt':
     ensure => 'present',
     content => 'Welcome to xFusionCorp Industries!',
     mode => '0777',
   }
 }
 node 'stapp01.stratos.xfusioncorp.com' {
   include file_modifier
 }
 
