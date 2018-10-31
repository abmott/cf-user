#!/usr/bin/env ruby
#set cftarget

# `cf login -a https://api.sys.prod.us-east-1.ds-csaa.io -u amott -p "what ever"`


target = `cf target`.split('.')
  #puts target[2]
  #puts target[3]

spaces = `cf spaces`.split("\n")
    spaces.delete_at(0)
    spaces.delete_at(0)
    spaces.delete_at(0)

spaces.each do |spaces|
  puts ""
  puts "-----------------------------------------------------"
  output = `cf space-users ds #{spaces}`
  puts output
#  puts "#{target[2]} #{target[3]} #{spaces} -- ~/Documents/cf_space_users/#{spaces}.users.txt file created"
#just a note
end
