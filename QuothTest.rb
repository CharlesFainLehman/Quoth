require "Quoth.rb"

f1 = File.new("A Christmas Carol.txt")
quoth1 = Quoth.new(f1.read)
f1.close

f2 = File.new("The Raven.txt")
quoth2 = Quoth.new(f2.read)
f2.close

puts quoth1.get(ARGV[0],ARGV[1].to_i)
quoth2.to_yaml("./output.yaml")
#puts (ARGV[0].split.length > 3 and ARGV[1].to_i > 0) ? test.get(ARGV[0],ARGV[1].to_i) : "improperly formatted arguments!"