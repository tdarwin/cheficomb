case node['random_sleep']
when 0..9
  chef_sleep 5
  include_recipe 'cheficomb::fail'
when 10..59
  chef_sleep 1
  include_recipe 'cheficomb::fail'
when 60..89 
  chef_sleep 2
  include_recipe 'cheficomb::fail'
else
  chef_sleep 3
  include_recipe 'cheficomb::fail'
end