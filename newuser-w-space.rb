#!/usr/bin/env ruby

require_relative 'colorize.rb' #text colorize for terminal output
require_relative 'passgen.rb' #random code generater for password

#check if variable is a number
class String
  def numeric?
    Float(self) != nil rescue false
  end
end

wrkdir = Dir.pwd

# variable order - username, generate password (y/n), org, space, role, {this option not used at this time -- more spaces (y/n)}

if ARGV[0] == "help" #Display help information
  then
    puts green("Command line Options")
    puts ""
    puts "    username"
    puts "    y or n - for password generation"
    puts "    org"
    puts "    space"
    puts "    role"
    puts yellow("        role options, the name or number can be used")
    print white ("        SpaceManager")
    print yellow(" or")
    print white (" 1")
    print yellow(",")
    print white (" SpaceDevelper")
    print yellow(" or")
    print white (" 2")
    print yellow(",")
    print white (" SpaceAuditor")
    print yellow(" or")
    puts white (" 3")
    puts ""
    puts "Example: ./newuser.rb username y org space SpaceAuditor"
    puts "Example: ./newuser.rb username y org space 3"
    puts ""
    puts ""
  exit
end

if not ARGV[0]
then
#Designate username
  puts ""
  print green("Enter New Username: -> ")
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

#Designate organization
if not ARGV[2]
  then
    orgs = `cf orgs`.split("\n")
        orgs.delete_at(0)
        orgs.delete_at(0)
        orgs.delete_at(0)
        puts ""
        puts green("Choose a Org:")
        orgcount = 1
        orgs.each do |orgs|
          print orgcount
          print ") "
          puts orgs
          orgcount = orgcount + 1
        end

    ARGV.clear
    print green("Org: -> ")
      org = gets.chop
      if org.numeric?
        then
        org = org.to_i
        org = org - 1
        org = orgs[org]
      end
  else org = ARGV[2]
  end
  
#Designate space
if not ARGV[3]
  then
      spaces = `cf spaces`.split("\n")
        spaces.delete_at(0)
        spaces.delete_at(0)
        spaces.delete_at(0)
        puts ""
        puts green("Choose a Space:")
          spacecount = 1
        spaces.each do |spaces|
          print spacecount
          print ") "
          puts spaces
          spacecount = spacecount + 1
        end

    ARGV.clear
    print green("Space: -> ")
      space = gets.chop
      if space.numeric?
        then
        space = space.to_i
        space = space - 1
        space = spaces[space]
      end
    else space = ARGV[3]
end

#Designate role
if not ARGV[4]
  then
  puts ""
  puts green("Choose a Role:")
  ARGV.clear
    puts white("1) SpaceManager")
    puts white("2) SpaceDeveloper")
    puts white("3) SpaceAuditor")
    print green("Role: -->")
      userrole = gets.chop
    else userrole = ARGV[4]
end

#check for short userrole value and give real value
case userrole
when "1"
  userrole = "SpaceManager"
when "2"
  userrole = "SpaceDeveloper"
when "3"
  userrole = "SpaceAuditor"
else
  userrole = userrole
end

#Create user
output = `cf create-user #{username} "#{password}"`
puts output
newuser = File.new("#{wrkdir}/cf_created_users/createduser.txt", "a")
newuser.puts "#{username} has been created and the password has been set to: #{password}"
newuser.close

print green("#{username}")
print white(" has been created and the password has been set to: ")
print green("#{password}")
puts white(" -- details written to #{wrkdir}/cf_created_users/createduser.txt")


#Assign space role individually as entered
puts ""
output = `cf set-space-role #{username} #{org} #{space} #{userrole}`
puts output
newrole = File.new("#{wrkdir}/cf_created_users/createduser.txt", "a")
newrole.puts "#{username} is now #{userrole} for #{org} #{space}"
newrole.close

print green("#{username}")
print (" is now ")
print green("#{userrole}")
print white(" for ")
print green("#{org} #{space}")
puts white(" -- details written to #{wrkdir}/cf_created_users/createduser.txt")
puts ""
