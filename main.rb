#!/usr/bin/env ruby
require 'time'
require './lib/ds18b20.rb'
require 'yaml'
require 'rest-client'
def now
  #2016-01-15T02:13:00.388Z
  t = Time.now
  t.iso8601
end

#plotly = PlotLy.new('LoganGarrett', ENV['plotly_api_key'])

def file_config
  meters = YAML.load_file('meters.yaml')
  meters.each do |meter|
    Temperature::DS18B20.new(hardware_id: meter['hardware_id'], name: meter['name'], tag_number: meter['tag_number']) if meter['active']
  end
end

def auto_config
  Temperature::DEVICES.each do |device|
    Temperature::DS18B20.new(hardware_id: device)
  end
end

def read_scopes
  Temperature::DS18B20.all_meters.each do |meter|
    puts "#{meter.hardware_id} - temp: #{meter.read}"
  end
end

def log_data
  endpoint = 'https://data.sparkfun.com/input'
  public_key = 'MGWW688WnRF6wgd8Zgz9'
  private_key = ENV['sparkfun_private_key']
  data_string = "#{endpoint}/#{public_key}?private_key=#{private_key}&timestamp=#{now}"

  Temperature::DS18B20.all_meters.each do |meter|
    reading = "&meter#{meter.tag_number}=#{meter.read}"
    data_string << reading
  end
  response = RestClient.get data_string
  puts response.body
end

file_config
loop do
  log_data
  sleep 30
end
