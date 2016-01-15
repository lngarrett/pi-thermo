#!/usr/bin/env ruby
require 'plotly'
require 'time'
require './lib/ds18b20.rb'
require 'yaml'

def now
  Time.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S")
end

plotly = PlotLy.new('LoganGarrett', ENV['plotly_api_key'])

def file_config
  meters = YAML.load_file('meters.yaml')
  meters.each do |meter|
    if meter['active'] Temperature::DS18B20.new(hardware_id: meter['hardware_id'], name: meter['name'], tag_number: meter['tag_number'])
end

def auto_config
  Temperature::DEVICES.each do |device|
    Temperature::DS18B20.new(hardware_id: device, name: 'Yeti Colster')
  end
end

def read_scopes
  Temperature::DS18B20.all_meters.each do |meter|
    puts "#{meter.hardware_id} - temp: #{meter.read}"
  end
end

def two_scope
  Temperature::DS18B20.new(hardware_id: '28-00000520ab0c', name: 'Yeti Colster')
  Temperature::DS18B20.new(hardware_id: '28-0000052100e5', name: 'Thermos Can Insulator')
  loop do
    Temperature::DS18B20.all_meters.each do |meter|
      puts "#{meter.name} - #{meter.read}"
    end

    data = [
      {
        x: [now],
        y: [Temperature::DS18B20.all_meters[0].read],
        name: Temperature::DS18B20.all_meters[0].name,
        marker: { color: 'rgb(55, 83, 109)' }
      },
      {
        x: [now],
        y: [Temperature::DS18B20.all_meters[1].read],
        name: Temperature::DS18B20.all_meters[1].name,
        marker: { color: 'rgb(26, 118, 255)' }
      },
    ]

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
    sleep 60
  end
end
