require 'json'
wrkdir = Dir.pwd
require_relative 'colorize.rb' #text colorize for terminal output

space_file_check = File.file?("#{wrkdir}/cf_spaces/spaces.txt")
if space_file_check == true
  then File.delete("#{wrkdir}/cf_spaces/spaces.txt")
end

if not ARGV[0]
then
#Designate Org to copy from
  puts ""
  print green("Source Org: -> ")
    source_org = gets.chop
  else source_org = ARGV[0]
end

org_command = JSON.parse(`cf curl /v2/organizations`)
org_command['resources'].each do |item|

org_metatadata_guid = item['metadata']['guid']
entity_name = item['entity']['name']
  if entity_name == source_org
    puts "#{entity_name} is guid #{org_metatadata_guid}"
    spaces = File.new("#{wrkdir}/cf_spaces/spaces.txt", "a")
    spaces.puts "#{entity_name} #{org_metatadata_guid}"
    spaces.close
  end
end
