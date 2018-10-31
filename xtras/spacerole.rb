#!/usr/bin/env ruby
require_relative 'colorize.rb'

#check if variable is a number
class String
  def numeric?
    Float(self) != nil rescue false
  end
end

#Command line variable information
if ARGV[0] == "help" #Display help on command line
    puts green("Command line Options")
    puts ""
    puts "    username"
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
    puts "    action"
    puts yellow("        action options, the name or number can be used")
    print white("        set")
    print yellow(" or")
    print white(" 1")
    print yellow(" to set the role, use ")
    print white("unset")
    print yellow(" or")
    print white (" 2")
    puts yellow(" to remove the role")
    puts ""
    puts "Example: ./spacerole.rb username org space SpaceAuditor set"
    puts "Example: ./spacerole.rb username org space 3 1"
    puts ""
    puts ""
  exit
end
# vaiable order - username, org, space, role
#Designate username

if not ARGV[0]
  then
    puts ""
    print green("Enter New Username: -> ")
      username = gets.chop
    else username = ARGV[0]
end

#Designate organization
if not ARGV[1]
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
else org = ARGV[1]
end

#Designate space
if not ARGV[2]
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
    else space = ARGV[2]
end

#Designate role
if not ARGV[3]
  then
  puts ""
  puts green("Choose a Role:")
  ARGV.clear
    puts white("1) SpaceManager")
    puts white("2) SpaceDeveloper")
    puts white("3) SpaceAuditor")
    print green("Role: -->")
      userrole = gets.chop
    else userrole = ARGV[3]
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

if not ARGV[4]
  then
  puts ""
  puts green("Choose an Action:")
  ARGV.clear
    puts white("1) Set")
    puts white("2) Unset")
    print green("Action -> ")
      setaction = gets.chop
    else setaction = ARGV[4]
end
#check for short userrole value and give real value
case setaction
when "1"
  setaction = "set"
when "2"
  setaction = "unset"
else
  setaction = setaction
end

output = `cf #{setaction}-space-role #{username} #{org} #{space} #{userrole}`
puts output
