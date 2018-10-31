#!/usr/bin/env ruby
require_relative 'colorize.rb' #text colorize for terminal output
require_relative 'passgen.rb' #random code generater for password
require 'highline/import'
require 'io/console'

wrkdir = Dir.pwd

#Declare cf targets to variable
pdcTarget = "uaa.sys.prod.pdc.digital.csaa-insurance.aaa.com"
gdcTarget = "uaa.sys.prod.gdc.digital.csaa-insurance.aaa.com"
sandTarget = "uaa.sys.sandbox.gdc.digital.pncie.com"

# variable order - username, generate password (y/n), environment, uaacpass}

if ARGV[0] == "help" #Display help information
  then
    puts green("Command line Options")
    puts ""
    puts "    username"
    puts "    y or n - for password generation"
    puts "    UAAC admin Password"
    puts "Example: ./newuser.rb username y uaacPassword"
    puts ""
    puts ""
  exit
end

#Designate username
if not ARGV[0]
then
  puts ""
  print green("Enter Username: -> ")
    username = gets.chop
  else username = ARGV[0]
end

#Generate random Password question (y/n)
if not ARGV[1]
  then
    puts ""
    print green("Do you wish to auto generate a password? [yn]")
    choice = gets.chop
  else
    choice = ARGV[1]
end

case choice

  when  "y", "Y", "yes", "Yes"
        password = generate_code(15, 3)
  when  "n", "N", "no", "No"
        puts green("Set Password: -> ")
        password = gets.chop
end

#Designate Environment
if not ARGV[2]
then
  puts ""
  print green("Enter Environment: -> ")
    targetEnv = gets.chop
  else targetEnv = ARGV[2]
end

case targetEnv

  when  "PDC", "pdc", "Pdc"
        targetEnv = pdcTarget
  when  "GDC", "gdc", "Gdc"
        targetEnv = gdcTarget
  when  "SANDBOX", "sandbox", "Sandbox", "sand", "tent", "TENT", "Tent"
        targetEnv = sandTarget
  else
        puts green("Invalid Environment - Enter Full target example: uaa.sys.sandbox.gdc.digital.pncie.com -->")
        targetEnv = gets.chop
end

#Designate admin account pass
if not ARGV[3]
then
  puts ""
  uaacpass = ask("Enter UAAC Password: -> ") { |q| q.echo="*" }
  #print green("Enter UAAC Password: -> ")
  #  uaacpass = STDIN.noecho(&:gets).chop
  else uaacpass = ARGV[3]
end

target = `uaac target #{targetEnv} --skip-ssl-validation`
connect = `uaac token client get admin -s "#{uaacpass}"`
passreset = `uaac password set #{username} -p "#{password}"`
puts passreset
puts "for #{username} to #{password}"
