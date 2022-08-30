ruby_block 'roll the random failure dice' do
  block do
    if node['random_fail'] > 90
      raise Exception.new "Failing because of a bad dice roll"
    end
  end
  action :run
end
