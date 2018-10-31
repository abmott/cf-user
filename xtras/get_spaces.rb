require 'json'
wrkdir = Dir.pwd
require_relative 'colorize.rb' #text colorize for terminal output



if not ARGV[0]
then
#Designate Org to copy from
  puts ""
  print green("Source Org: -> ")
    source_org = gets.chop
  else source_org = ARGV[0]
end

space_file_check = File.file?("#{wrkdir}/cf_spaces/#{source_org}-spaces.txt")
if space_file_check == true
  then File.delete("#{wrkdir}/cf_spaces/#{source_org}-spaces.txt")
end

org_command = JSON.parse(`cf curl /v2/organizations`)
org_command['resources'].each do |item|

org_metatadata_guid = item['metadata']['guid']
org_entity_name = item['entity']['name']
  if org_entity_name == source_org
    org_entity_guid = org_metatadata_guid
    #puts "#{org_entity_name} is guid #{org_metatadata_guid}"
    #spaces = File.new("#{wrkdir}/cf_spaces/spaces.txt", "a")
    #spaces.puts "#{org_entity_name} #{org_metatadata_guid}"
    #spaces.close
  end
  space_command = JSON.parse(`cf curl /v2/spaces`)
  space_command['resources'].each do |item|

  metatadata_guid = item['metadata']['guid']

  space_entity_name = item['entity']['name']
  space_entity_name_guid = item['entity']['organization_guid']
    if space_entity_name_guid == org_entity_guid
      puts space_entity_name
      spaces = File.new("#{wrkdir}/cf_spaces/#{source_org}-spaces.txt", "a")
      spaces.puts "#{space_entity_name}"
      spaces.close
    end
  end
end
