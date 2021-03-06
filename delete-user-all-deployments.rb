#!/usr/bin/env ruby

require_relative 'colorize.rb' #text colorize for terminal output
require 'optparse' #used to parse command-line arrguments
require 'open3'

#check if variable is a number
class String
  def numeric?
    Float(self) != nil rescue false
  end
end

#Declare cf targets to variable

prodTarget = "https://api.sys.prod.smarsh.cloud"
#backupTarget = "https://api.sys.prod.backup.digital.csaa-insurance.aaa.com"
sandTarget = "https://api.sys.pcfdemo.smarsh.cloud"

wrkdir = Dir.pwd

# variable order - username, adminaccnt, prodpass, backuppass, sandpass, org}
options = {:username => nil, :admin => nil, :prodpass => nil, :backuppass => nil, :sandboxpass => nil, :org => nil, :masterpass => nil}

parser = OptionParser. new do|opts|
  opts.banner = "Usage user.rb [options]"
  opts.on('-u', '--username user.name@email.com', 'Username Example: first.last@email.com') do |username|
    options[:username] = username
  end

  opts.on('-a', '--admin admin', 'Admin account for the pcf deployment') do |admin|
    options[:admin] = admin
  end

  opts.on('-p', '--prodpass prodpass', 'prod password for used admin account') do |prodpass|
    options[:prodpass] = prodpass
  end

  opts.on('-g', '--backuppass backuppass', 'backup password for used admin account') do |backuppass|
    options[:backuppass] = backuppass
  end

  opts.on('-s', '--sandboxpass sandboxpass', 'Sandbox password for used admin account') do |sandboxpass|
    options[:sandboxpass] = sandboxpass
  end

  opts.on('-m', '--masterpass masterpass', 'Master password if same for all enviornments for used admin account') do |masterpass|
    options[:masterpass] = masterpass
  end

  opts.on('-o', '--org org', 'PCF Organization account is being deleted') do |org|
    options[:org] = org
  end

  opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end

parser.parse!

#check for master password
if options[:masterpass] != nil
  then
  options[:prodpass] = options[:masterpass]
  options[:backuppass] = options[:masterpass]
  options[:sandboxpass] = options[:masterpass]
end

#Designate username
if options[:username] == nil
  puts ""
  print green("Enter New Username: -> ")
    options[:username] = STDIN.gets.chomp
end

#Designate admin account user
if options[:admin] == nil
  puts ""
  print green("Enter Admin Account: -> ")
    options[:admin] = STDIN.gets.chomp
end

#Designate prod Password
if options[:prodpass] == nil
  puts ""
  print green("Enter Prod Password: -> ")
    options[:prodpass] = STDIN.gets.chomp
    nothing = "*" * options[:prodpass].length
    puts nothing
end

#Designate backup Password
if options[:backuppass] == nil
  puts ""
  print green("Enter Backup Password: -> ")
    options[:backuppass] = STDIN.gets.chomp
    nothing = "*" * options[:backuppass].length
    puts nothing
end

#Designate Sandbox Password
if options[:sandboxpass] == nil
  puts ""
  print green("Enter Sandbox Password: -> ")
    options[:sandboxpass] = STDIN.gets.chomp
    nothing = "*" * options[:sandboxpass].length
    puts nothing
end

#Designate which org
if options[:org] == nil
  puts ""
  print green("Enter Target Org: -> ")
  options[:org] = STDIN.gets.chomp
end

#Log into cf targets
#target = [[prodTarget,options[:prodpass]], [backupTarget,options[:backuppass]], [sandTarget,options[:sandboxpass]]]
target = [[prodTarget,options[:sandboxpass]], [sandTarget,options[:sandboxpass]]]
target.each do |targets|
  target = targets[0]
  puts target
  pass = targets[1]
  #puts pass
  stdout, stderr, status = Open3.capture3("cf login -a #{target} -o #{options[:org]} -u #{options[:admin]} -p '#{pass}' -s none")
    if stdout.include? "rejected"
      puts "Bad Credentials for #{options[:admin]} @ #{target}"
      exit
    end    #Delete user
  output = `cf delete-user #{options[:username]} -f 2>&1`
  if output.include? "does not exist"
    puts "User #{options[:username]} does not exist"
  else
    #puts output
    print green("#{options[:username]}")
    print white(" has been")
    print red(" deleted")
    puts white(" from #{target}")
  end
end
