class multi_package_node {

  package { 'vim-enhanced': ensure => 'installed' }
  package { 'zip': ensure => 'installed' }
}
node 'stapp02.stratos.xfusioncorp.com' {
  include multi_package_node
}
