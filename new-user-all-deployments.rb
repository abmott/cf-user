#!/usr/bin/env ruby

require_relative 'colorize.rb' #text colorize for terminal output
require_relative 'passgen.rb' #random code generater for password
require_relative 'send_email.rb' #used to send user account and password emails
require 'io/console' #used to hide password values
require 'optparse' #used to parse command-line arrguments
require 'open3'
require 'json'

#check if variable is a number
class String
  def numeric?
    Float(self) != nil rescue false
  end
end

#Declare cf targets to variable
#prodTarget = "https://api.sys.prod.prod.digital.csaa-insurance.aaa.com"
#backupTarget = "https://api.sys.prod.backup.digital.csaa-insurance.aaa.com"
#sandTarget = "https://api.sys.pcfdemo.smarsh.cloud"
wrkdir = Dir.pwd
params_file = File.read("#{wrkdir}/params.json")
params = JSON.parse(params_file)

user_exists = false

wrkdir = Dir.pwd

options = {:username => nil, :createpass => nil, :admin => nil, :prodpass => nil, :backuppass => nil, :sandboxpass => nil, :org => nil, :masterpass => nil}

parser = OptionParser. new do|opts|
  opts.banner = "Usage user.rb [options]"
  opts.on('-u', '--username user.name@email.com', 'Username Example: first.last@email.com') do |username|
    options[:username] = username.downcase
  end

  opts.on('-c', '--createpass createpass', 'Y or N (yes or no) to create a random password') do |createpass|
    options[:createpass] = createpass
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

  opts.on('-o', '--org org', 'PCF Organization account is being created') do |org|
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

#Generate random Password question (y/n)
if options[:createpass] == nil
    puts ""
    print green("Do you wish to auto generate a password? [yn]")
    options[:createpass] = STDIN.gets.chomp
end

case options[:createpass]

  when  "y", "Y", "yes", "Yes"
        password = generate_code(15, 3)
  when  "n", "N", "no", "No"
        puts green("Set Password: -> ")
        password = STDIN.gets.chomp
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
  print green("Enter prod Password: -> ")
    options[:prodpass] = STDIN.noecho(&:gets).chomp
    nothing = "*" * options[:prodpass].length
    puts nothing
end

#Designate backup Password
if options[:backuppass] == nil
  puts ""
  print green("Enter backup Password: -> ")
    options[:backuppass] = STDIN.noecho(&:gets).chomp
    nothing = "*" * options[:backuppass].length
    puts nothing
end

#Designate Sandbox Password
if options[:sandboxpass] == nil
  puts ""
  print green("Enter Sandbox Password: -> ")
    options[:sandboxpass] = STDIN.noecho(&:gets).chomp
    nothing = "*" * options[:sandboxpass].length
    puts nothing
end

#Designate which org
if options[:org] == nil
  puts ""
  print green("Enter Target Org: -> ")
  options[:org] = STDIN.gets.chomp
end

#puts "user: #{options[:username]}, Crete pass: #{options[:createpass]}, Admin: #{options[:admin]}, prodpass: #{options[:prodpass]}, backuppass: #{options[:backuppass]}, Sandpass:#{options[:sandboxpass]}, org: #{options[:org]} "
#Log into cf targets
env_user = Hash.new
#target = [[prodTarget,options[:prodpass]], [backupTarget,options[:backuppass]], [sandTarget,options[:sandboxpass]]]
target = [[params['sandbox']['target'],options[:sandboxpass]]]
target.each do |targets|
  user_exists = false
  target, pass = targets[0], targets[1]
  #puts "cf login -a #{target} -o #{options[:org]} -u #{options[:admin]} -p #{pass} -s none"
  #connect = `cf login -a #{target} -o #{options[:org]} -u #{options[:admin]} -p "#{pass}" -s none`
  #puts connect
  stdout, stderr, status = Open3.capture3("cf login -a #{target} -o #{options[:org]} -u #{options[:admin]} -p '#{pass}' -s none")
    if stdout.include? "rejected"
      puts "Bad Credentials for #{options[:admin]} @ #{target}"
      exit
    end
    if stdout.include? "Error building request: parse"
      puts "No API endpoint set - check connection string -- #{stdout}"
      exit
    end
  output = `cf create-user #{options[:username]} "#{password}" 2>&1`
  #puts output
  puts "Creating user #{options[:username].downcase} in #{target}"
  if output.include? "already exists"
    puts red("User #{options[:username]} already exists in #{target}")
    user_exists = true
    env_user.merge!("#{target}": "#{user_exists}")
  else
    env_user.merge!("#{target}": "#{user_exists}")
    puts green("Account has been created for #{options[:username]} in #{target}")
    newuser = File.new("#{wrkdir}/cf_created_users/createduser.txt", "a")
    newuser.puts "#{options[:username]} has been created and the password has been set to: #{password} for #{target}"
    newuser.close
  end
end

env_user.each do |k, v|
  #puts "#{k}, #{v}"
  #check for short userrole value and give real value

  env = k.to_s
  #puts env
  if env.include? "#{params['prod']['environment']}" #part of the api url
    env = "prod"
  elsif env.include? "#{params['backup']['environment']}" #part of the api url
    env = "backup"
  elsif env.include? "#{params['sandbox']['environment']}" #part of the api url
    env = "sandbox"
  else
    puts "no match"
    env = k
  end
  #puts env
  if v == "true"
    puts red("No account created in #{env}, no email sent")
  elsif options[:username].include? "ci-" #no email for ci accounts
  puts green("no email for service account")
  else
    #puts "email would be sent"
    #puts env
    #puts params["#{env}"]['target']
    send_email("#{options[:username]}", "#{password}", "#{env}", "#{params["#{env}"]['pcf_login_url']}", "#{params["#{env}"]['pcf_api_url']}", "#{params["#{env}"]['send_email_from']}", "#{params["#{env}"]['send_email_domain']}","#{params["#{env}"]['send_email_user']}","#{params["#{env}"]['send_email_api_key']}","#{params["#{env}"]['smtp_endpoint']}")
    puts "********************************************************************************************************"
    puts "An email notification has been sent to #{options[:username]} with account and password for #{env}"
    puts "********************************************************************************************************"
  end
end
