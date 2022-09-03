$public_key =  'AAAAB3NzaC1yc2EAAAADAQABAAABAQCv9SvO48stgnPikHDVnULiwKVBG2fN7YPPJ8wTm/g2Kha+7ZS7lJ/8vgJL7YWkiUlx+f5PfZ8ftsMfkrf/lgxSK/Yu9MdXqcO7IN0P7QvKl1aYEsgwhRwGoXMSDaETH7HuhC3Nng6UiyG5M9/QibOvmQ3nPXLcfOcVB0fuZDTA3tBGYUZ9GbhAHHzwnGIHfayUHQxhrGkjJHhC7kg+uY+li4ABa2grKLTDHKXFbnptbX9QZCtJRg7HYIrLWnMLqZMi24caWn5dPo9+3MKRR2PZfjyHVHxBA0EmxRTkmwAXwq6G/h7/P15uFXf+XQQuelW1JOflmLt5v89Fk/wQs6xP'

class ssh_node1 {
   ssh_authorized_key { 'tony@stapp01':
     ensure => present,
     user   => 'tony',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

class ssh_node2 {
   ssh_authorized_key { 'steve@stapp02':
     ensure => present,
     user   => 'steve',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

class ssh_node3 {
   ssh_authorized_key { 'banner@stapp03':
     ensure => present,
     user   => 'banner',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

node stapp01.stratos.xfusioncorp.com {
   include ssh_node1
}

node stapp02.stratos.xfusioncorp.com {
   include ssh_node2
}

node stapp03.stratos.xfusioncorp.com {
   include ssh_node3
}
