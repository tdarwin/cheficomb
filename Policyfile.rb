# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'cheficomb'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'cheficomb::default', 'os-hardening::default'

# Specify a custom source for a single cookbook:
cookbook 'cheficomb', path: '.'
cookbook 'os-hardening', git: 'https://github.com/dev-sec/chef-os-hardening.git', tag: 'v4.0.0'
