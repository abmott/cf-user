#!/usr/bin/env ruby
require_relative 'colorize.rb' #text colorize for terminal output
require_relative 'passgen.rb' #random code generater for password
require_relative 'get_token'
require 'highline/import'
require 'io/console'

wrkdir = Dir.pwd

#Declare cf targets to variable
pdcTarget = "uaa.sys.prod.pdc.digital.csaa-insurance.aaa.com"
gdcTarget = "uaa.sys.prod.gdc.digital.csaa-insurance.aaa.com"
sandTarget = "uaa.sys.sandbox.gdc.digital.pncie.com"

options = {:username => nil, :pdcuaacpass => nil, :gdcuaacpass => nil, :sandboxuaacpass => nil}

parser = OptionParser. new do|opts|
  opts.banner = "Usage user.rb [options]"
  opts.on('-u', '--username user.name@email.com', 'Username Example: first.last@email.com') do |username|
    options[:username] = username
  end

  opts.on('-p', '--pdcuaacpass pdcuaacpass', 'UAAC password for PDC PCF enviornment') do |pdcuaacpass|
    options[:pdcuaacpass] = pdcuaacpass
  end

  opts.on('-g', '--gdcuaacpass gdcuaacpass', 'UAAC password for GDC PCF enviornment') do |gdcuaacpass|
    options[:gdcuaacpass] = gdcuaacpass
  end

  opts.on('-s', '--sandboxuaacpass sandboxuaacpass', 'UAAC password for Sandbox PCF enviornment') do |sandboxuaacpass|
    options[:sandboxuaacpass] = sandboxuaacpass
  end

  opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end

parser.parse!


#Designate username
if options[:username] == nil
  puts ""
  print green("Enter New Username: -> ")
    options[:username] = STDIN.gets.chomp
end

#Designate admin account pass
if options[:pdcuaacpass] == nil
  puts ""
  pdcuaacpass = ask("Enter PDC UAAC Password: -> ") { |q| q.echo="*" }
end

if options[:gdcuaacpass] == nil
  puts ""
  pdcuaacpass = ask("Enter GDC UAAC Password: -> ") { |q| q.echo="*" }
end

if options[:sandboxuaacpass] == nil
  puts ""
  pdcuaacpass = ask("Enter Sandbox UAAC Password: -> ") { |q| q.echo="*" }
end

target = [[pdcTarget,options[:pdcuaacpass]], [gdcTarget,options[:gdcuaacpass]], [sandTarget,options[:sandboxuaacpass]]]
target.each do |targets|
  uaactarget, uaacpass = targets[0], targets[1]
  puts "---------------------------------------------"
  output = `uaac target #{uaactarget} --skip-ssl-validation`
  #puts output
  #get_token("admin", "#{uaacpass}", "https://#{uaactarget}" )
  connect = `uaac token client get admin -s "#{uaacpass}"`
  #puts connect
  unlockaccount = `uaac user unlock "#{options[:username]}"`
  puts unlockaccount
  puts "#{options[:username]} has been unlocked on #{uaactarget}"
end
puts "---------------------------------------------"
