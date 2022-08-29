#
# Cookbook:: cheficomb
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

Chef.event_handler do
  trace_id = SecureRandom.hex(16)
  root_span_id = SecureRandom.hex(8)
  compile_span_id = SecureRandom.hex(8)
  converge_span_id = SecureRandom.hex(8)
  # compliance_span_id = SecureRandom.hex(8)
  trace_batch = []
  comp_start = Time.parse(Time.now.xmlschema(fraction_digits = 4))
  @conv_start = Time.parse(Time.now.xmlschema(fraction_digits = 4))
  puts "First Converge Start Time = #{@conv_start.xmlschema(fraction_digits = 4)}"

  on :cookbook_compilation_complete do
    comp_stop = Time.parse(Time.now.xmlschema(fraction_digits = 4))
    comp_duration = comp_stop - comp_start
    comp_duration_ms = comp_duration * 1000

    compile_span = ::Honeycomb.generate_span(
      @run_status,
      trace_id: trace_id,
      span_id: compile_span_id,
      parent_id: root_span_id,
      timestamp: comp_start.xmlschema(fraction_digits = 4),
      duration_ms: comp_duration_ms,
      start_time: comp_start.xmlschema(fraction_digits = 4),
      end_time: comp_stop.xmlschema(fraction_digits = 4),
      event: 'compile',
    )

    trace_batch << compile_span
  end
  Chef::Client.when_run_starts {|run_status| @handler.instance_variable_set(:@run_status, run_status) }
  on :converge_start do
    @conv_start = Time.parse(Time.now.xmlschema(fraction_digits = 4))
    puts "Converge Start Event Time = #{@conv_start.xmlschema(fraction_digits = 4)}"
  end
  on :converge_complete do
    @conv_stop = Time.parse(Time.now.xmlschema(fraction_digits = 4))
    conv_duration = @conv_stop - @conv_start
    conv_duration_ms = conv_duration * 1000

    puts "Final Converge Start Time = #{@conv_start.xmlschema(fraction_digits = 4)}"
    puts "Converge Stop Time = #{@conv_stop.xmlschema(fraction_digits = 4)}"
    span = ::Honeycomb.generate_span(
      @run_status,
      trace_id: trace_id,
      span_id: converge_span_id,
      parent_id: root_span_id,
      timestamp: @conv_start.xmlschema(fraction_digits = 4),
      duration_ms: conv_duration_ms,
      start_time: @conv_start.xmlschema(fraction_digits = 4),
      end_time: @conv_stop.xmlschema(fraction_digits = 4),
      event: 'converge',
    )
    trace_batch << span
  end
  on :converge_failed do
    @conv_stop = Time.parse(Time.now.xmlschema(fraction_digits = 4))
    conv_duration = @conv_stop - @conv_start
    conv_duration_ms = conv_duration * 1000

    puts "Final Converge Start Time = #{@conv_start.xmlschema(fraction_digits = 4)}"
    puts "Converge Stop Time = #{@conv_stop.xmlschema(fraction_digits = 4)}"
    span = ::Honeycomb.generate_span(
      @run_status,
      trace_id: trace_id,
      span_id: converge_span_id,
      parent_id: root_span_id,
      timestamp: @conv_start.xmlschema(fraction_digits = 4),
      duration_ms: conv_duration_ms,
      start_time: @conv_start.xmlschema(fraction_digits = 4),
      end_time: @conv_stop.xmlschema(fraction_digits = 4),
      event: 'converge',
    )
    trace_batch << span
  end
  on :resource_action_start do
    |resource|
    @recipe_span = SecureRandom.hex(8)
    @resource_start = Time.parse(Time.now.xmlschema(fraction_digits = 4))
  end
  on :resource_completed do
    |resource|
    resource_stop = Time.parse(Time.now.xmlschema(fraction_digits = 4))
    resource_start = (resource_stop - (resource.elapsed_time * 1000)).xmlschema(fraction_digits = 4)
    span = ::Honeycomb.generate_span(
      @run_status,
      trace_id: trace_id,
      span_id: SecureRandom.hex(8),
      timestamp: resource_start,
      parent_id: converge_span_id,
      duration_ms: resource.elapsed_time * 1000,
      start_time: resource_start,
      end_time: resource_stop.xmlschema(fraction_digits = 4),
      resource_name: resource.to_s,
      resource_recipe: resource.recipe_name,
      resource_cookbook: resource.cookbook_name,
      resource_action: resource.action,
      event: resource.to_s,
    )
    trace_batch << span
  end
  Chef::Client.when_run_completes_successfully {|run_status| @handler.instance_variable_set(:@run_status, run_status) }
  Chef::Client.when_run_fails {|run_status| @handler.instance_variable_set(:@run_status, run_status) }
  on :run_completed do
    root_trace = ::Honeycomb.generate_span(@run_status, trace_id: trace_id, span_id: root_span_id, end_run: true, timestamp: @run_status.start_time)
    trace_batch << root_trace
    ::Honeycomb.report(@run_status, trace_batch)
    # Chef::Handler::JsonFile(@run_status, path: '/tmp/reports')
  end
  on :run_failed do
    root_trace = ::Honeycomb.generate_span(@run_status, trace_id: trace_id, span_id: root_span_id, end_run: true, timestamp: @run_status.start_time)
    trace_batch << root_trace
    ::Honeycomb.report(@run_status, trace_batch)
    # Chef::Handler::JsonFile(@run_status, path: '/tmp/reports')
  end
end

case node['random_files']
when 0
  2.times do
    file "/tmp/#{SecureRandom.hex(10)}.file" do
      content SecureRandom.hex(30)
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end
  # chef_sleep 4
when 1..49
  5.times do
    file "/tmp/#{SecureRandom.hex(10)}.file" do
      content SecureRandom.hex(30)
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end
  # chef_sleep 3
when 50..79 
  10.times do
    file "/tmp/#{SecureRandom.hex(10)}.file" do
      content SecureRandom.hex(30)
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end
  # chef_sleep 2
else
  15.times do
    file "/tmp/#{SecureRandom.hex(10)}.file" do
      content SecureRandom.hex(30)
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end
  # chef_sleep 1
end
