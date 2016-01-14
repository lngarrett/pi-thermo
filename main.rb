#!/usr/bin/env ruby
require './lib/ds18b20.rb'

Temperature::DEVICES.each do |device|
  Temperature::DS18B20.new(hardware_id: device)
end

puts Temperature::DS18B20.all_meters
