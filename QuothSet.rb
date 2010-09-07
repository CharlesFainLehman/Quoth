require "time"

class QuothSet
	@corpus
	
	def initialize(text)
		@corpus = {}
		set = text.split
		set.each_index do |i|
			if i < set.length - 1 then #only to the second to last word
				@corpus.has_key?(set[i]) ? @corpus[set[i]] << set[i+1] : @corpus[set[i]] = [set[i+1]]
			end
		end
	end
	
	def get(startWord, length)
		ret = ""
		word = startWord
		count = 0
		
		while @corpus.has_key? word and count < length
			newWord = @corpus[word][rand(@corpus[word].length)]
			ret << newWord + " " #get the value at a random position of the array returned as the value of the key word
			word = newWord
			count += 1
		end
		
		ret
	end
	
	def addSet(key, value)
		@corpus.has_key? key ? @corpus[key] << value : @corpus[key] = [value]
	end
	
	def addText(text)
		set = text.split
		set.each_index do |i|
			if i < set.length - 1 then addSet(set[i],set[i+1]) end
		end
	end
	
	def write
		f = File.new("quoths #{Time.new.to_s.gsub(/:/,"")}.txt", "w+")
		f << to_s
		f.close
	end
	
	def to_s
		ret = ""
		@corpus.each_pair do |key, value|
			ret << "#{key.to_s} => ["
			for word in value do ret << word + "," end
			ret.chop!
			ret << "], "
		end
		ret.chop.chop
	end
end

f = File.new("test.txt")
test = QuothSet.new(f.read)
f.close
#puts test
puts test.get("I",ARGV[0].to_i)
#test.write