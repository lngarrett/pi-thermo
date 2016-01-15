module Temperature
    DEVICE_PATH = "/sys/bus/w1/devices"
    DEVICES = %x( ls /sys/bus/w1/devices | grep 28 ).split
  class DS18B20
    @@array = Array.new
    attr_accessor :name, :hardware_id, :tag_number, :device_path
    def initialize options = {}
      @name        = options[:name]        || options[:hardware_id]
      @tag_number  = options[:tag_number]  || options[:hardware_id]
      @device_path = options[:device_path] || DEVICE_PATH
      @hardware_id = options[:hardware_id] || find_hardware_id
      @@array     << self
    end

    def self.all_meters
      @@array
    end

    def find_hardware_id
      w1_devices[0].gsub("#{device_path}/",'')
    end

    def w1_devices
      Dir["#{device_path}/28*"]
    end

    def read
      raw = read_raw

      if tempC = parse(raw)
        tempF = to_fahrenheit tempC
      else
        tempC
      end
    end

    def parse raw_data
      if temp_data = raw_data.match(/t=([0-9]+)/)
        temp_data[1].to_f / 1000
      else
        nil
      end
    end

    def to_fahrenheit temp
      ((temp * 1.8) + 32).round(3)
    end

    def read_raw
      File.read device_file
    end

    def device_file
      "/sys/bus/w1/devices/#{@hardware_id}/w1_slave"
    end
  end
end
