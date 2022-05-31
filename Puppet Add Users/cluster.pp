class user_creator {
  user { 'jim':
    ensure   => present,
    uid => 1302,
  }
}
node 'stapp01.stratos.xfusioncorp.com' {
include user_creator
}
