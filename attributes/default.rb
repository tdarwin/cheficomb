default['audit']['compliance_phase'] = false

default['random_files'] = SecureRandom.random_number(99)
default['random_fail'] = SecureRandom.random_number(99)

default['honeycomb']['writekey'] = "<API_KEY_GOES_HERE>"
default['honeycomb']['api_url'] = "https://api.honeycomb.io"
default['honeycomb']['dataset'] = "chef"
default['honeycomb']['automate_fqdn'] = "automate.example.com"
default['honeycomb']['tracked_attributes'] = {
  'chef.node.random_files' => node['random_files'],
  'chef.node.random_fail' => node['random_fail'],
  'chef.node.audit.compliance_phase' => node['audit']['compliance_phase'],
  'myapp.version' => node['myapp']['version'],
  'yourapp.version' => node['yourapp']['version'],
}
