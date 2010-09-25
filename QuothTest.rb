require "Quoth.rb"

#load from file
quoth1 = Quoth.new("A Christmas Carol.txt")

#load from YAML
quoth2 = Quoth.new("The Raven.yaml")

puts "Quoth 1: " + quoth1.get(ARGV[0],ARGV[1].to_i)
puts "Quoth 2: " + quoth2.get(ARGV[0],ARGV[1].to_i)

#puts (ARGV[0].split.length > 3 and ARGV[1].to_i > 0) ? test.get(ARGV[0],ARGV[1].to_i) : "improperly formatted arguments!"