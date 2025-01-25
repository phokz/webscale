#!/usr/bin/env ruby

require 'sinatra'
require 'serialport'
require 'json'

path = File.dirname(File.expand_path(__FILE__))

port = ENV['SCALE_SERIAL_PORT'] || '/dev/ttyUSB0'
baud_rate = ENV['SCALE_BAUD_RATE'] || 9600
sp = SerialPort.new(port, baud_rate)
sp.sync = true


def read_serial(sp)
  chars = [ ] 
  20.times.map do
   v = sp.getc;
   break if v=="\n"
   chars << v
  end
  puts chars.inspect
  {
   weight: chars[0..8].join.delete(' ').to_f,
   unit: chars[9..11].join.strip
  }

end

get '/' do
  sp.write("\x1b\x70")
  data = read_serial(sp)
  File.read(path+'/page.html').gsub('_WEIGHT_', data[:weight].to_s).gsub('_UNIT_', data[:unit])
end

post '/unit' do
 sp.write("\x1b\x73")
 redirect('/')
end

post '/tare' do
 sp.write("\x1b\x74")
 sleep 1
 redirect('/')
end

get '/api/scale.json' do
  sp.write("\x1b\x70")
  read_serial(sp).to_json
end

post '/api/unit.json' do
 sp.write("\x1b\x73")
 sp.write("\x1b\x70")
 data = read_serial(sp)
 data.delete(:weight)
 data.to_json
end

post '/api/tare.json' do
 sp.write("\x1b\x74")
end
