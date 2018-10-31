#!/usr/bin/env ruby

print "Enter New Username: -> "
  username = gets.chop

target = `cf target`.split('.')

spaces = `cf spaces`.split("\n")
      spaces.delete_at(0)
      spaces.delete_at(0)
      spaces.delete_at(0)

wrkdir = Dir.pwd
userspaces = []
spaces.each do |spaces|
if File.readlines("#{wrkdir}/cf_space_users/#{target[2]}_#{target[3]}_#{spaces}_users.txt").grep(/#{username}/).size > 0
          userspaces << spaces
  end
end

puts userspaces
