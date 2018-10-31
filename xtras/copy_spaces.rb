require_relative 'colorize.rb' #text colorize for terminal output
wrkdir = Dir.pwd

if not ARGV[0]
then
#Designate Org to copy from
  puts ""
  print green("Source Org: -> ")
    source_org = gets.chop
  else source_org = ARGV[0]
end

if not ARGV[1]
then
#Designate Org to copy to
  puts ""
  print green("Desitnation Org: -> ")
    destination_org = gets.chop
  else destination_org = ARGV[1]
end

File.open("#{wrkdir}/cf_spaces/#{source_org}-spaces.txt").each do |space|
    spaces = space.delete!("\n")
    #puts spaces
   output = `cf create-space #{spaces} -o #{destination_org}`
   puts output

end

puts "Finished"
