#!/usr/bin/env ruby
#set cftarget

# `cf login -a https://api.sys.prod.us-east-1.ds-csaa.io -u amott -p "what ever"`

wrkdir = Dir.pwd

target = `cf target`.split('.')
  #puts target[2]
  #puts target[3]

spaces = `cf spaces`.split("\n")
    spaces.delete_at(0)
    spaces.delete_at(0)
    spaces.delete_at(0)

spaces.each do |spaces|
  `cf space-users ds #{spaces} > #{wrkdir}/cf_space_users/#{target[2]}_#{target[3]}_#{spaces}_users.txt`
  puts "#{target[2]} #{target[3]} #{spaces} -- #{wrkdir}/cf_space_users/#{spaces}_users.txt file created"
end
