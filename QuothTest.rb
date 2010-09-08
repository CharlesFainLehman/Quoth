require "Quoth.rb"

f = File.new("A Christmas Carol.txt")
test = Quoth.new(f)
f.close
puts test.get(ARGV[0],ARGV[1].to_i)
test.to_yaml("./output.yaml")
#puts (ARGV[0].split.length > 3 and ARGV[1].to_i > 0) ? test.get(ARGV[0],ARGV[1].to_i) : "improperly formatted arguments!"