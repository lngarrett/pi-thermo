#!/usr/bin/env ruby
require 'plotly'
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

# def two_scope
#   Temperature::DS18B20.new(hardware_id: '28-00000520ab0c', name: 'Yeti Colster')
#   Temperature::DS18B20.new(hardware_id: '28-0000052100e5', name: 'Thermos Can Insulator')
#   loop do
#     Temperature::DS18B20.all_meters.each do |meter|
#       puts "#{meter.name} - #{meter.read}"
#     end
#
#     data = [
#       {
#         x: [now],
#         y: [Temperature::DS18B20.all_meters[0].read],
#         name: Temperature::DS18B20.all_meters[0].name,
#         marker: { color: 'rgb(55, 83, 109)' }
#         stream:{ token: token}
#       },
#       {
#         x: [now],
#         y: [Temperature::DS18B20.all_meters[1].read],
#         name: Temperature::DS18B20.all_meters[1].name,
#         marker: { color: 'rgb(26, 118, 255)' }
#         stream:{ token: token}
#       },
#     ]
#
#     args = {
#       filename: 'temperature',
#       fileopt: 'extend',
#       style: { type: 'scatter' },
#       layout: {
#         title: 'Temperature'
#       },
#       world_readable: true
#     }
#
#     plotly.plot(data, args) do |response|
#       puts response['url']
#     end
#     sleep 60
#   end
# end

def log_data
  endpoint = 'http://data.sparkfun.com/input/'
  public_key = 'MGWW688WnRF6wgd8Zgz9'
  private_key = ENV['sparkfun_private_key']
  data_string = "#{endpoint}/input/#{public_key}?private_key=#{private_key}&timestamp=#{now}"

  Temperature::DS18B20.all_meters.each do |meter|
    reading = "&sensor#{meter.tag_number}=#{meter.read}"
    data_string << reading
    puts data_string
  end
  RestClient.get data_string
end

file_config
read_scopes
log_data
