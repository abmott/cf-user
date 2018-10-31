require 'json'
require 'io/console'
require_relative 'colorize.rb' #text colorize for terminal output
wrkdir = Dir.pwd
#def cf_login

logged_in = 1

while logged_in == 1 do

if not ARGV[0]
then
#Designate source environment
  puts ""
  print green("Enter Source Environment: -> ")
    source_environment = gets.chomp
  else source_environment = ARGV[0]
end

if not ARGV[1]
then
#Designate source environment
  puts ""
  print green("Enter Username: -> ")
    source_environment_username = gets.chomp
  else source_environment_username = ARGV[1]
end

if not ARGV[2]
then
#Designate source environment
  puts ""
  print green("Enter Password: -> ")
    source_environment_pass = STDIN.noecho(&:gets).chomp
    #STDIN.echo=true
    puts ""
  else source_environment_pass = ARGV[2]
end

#check for short environment value and give real value
case source_environment
when "sandbox"
  source_environment = "https://api.sys.sandbox.gdc.digital.pncie.com"
when "pdc"
  source_environment = "https://api.sys.prod.pdc.digital.csaa-insurance.aaa.com"
when "gdc"
  source_environment = "https://api.sys.prod.gdc.digital.csaa-insurance.aaa.com"
else
  puts = "Invalid environment"
end
#def
 cf_login_cmd = "cf login -u #{source_environment_username} -p '#{source_environment_pass}' -a #{source_environment}"
#puts cf_login_cmd
 IO.popen(cf_login_cmd, "r+") do |pipe|
   pipe.close_write
   string = pipe.read

   #puts string

   if string.include?('OK')
     puts ''
    puts green("Login Successful you are now logged in to:")
    logged_in = 2
  else
    puts ''
    puts red("Login Unsucessful - please try again")
    logged_in = 1
  end
end
end

output = `cf target`
puts output
#end
