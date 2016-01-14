#!/usr/bin/env ruby
require 'plotly'
require 'time'
require './lib/ds18b20.rb'

def now
  Time.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
end

plotly = PlotLy.new('LoganGarrett', ENV['plotly_api_key'])

# Setup an array of thermometers
Temperature::DEVICES.each do |device|
  Temperature::DS18B20.new(hardware_id: device)
end

Temperature::DS18B20.all_meters.each do |meter|
  puts meter.read
end

data = {
  x: [now],
  y: [Temperature::DS18B20.all_meters[0].read]
}

args = {
  filename: 'temperature',
  fileopt: 'extend',
  style: { type: 'scatter' },
  layout: {
    title: 'Temperature'
  },
  world_readable: true
}

plotly.plot(data, args) do |response|
  puts response['url']
end
