require "time"

class Quoth
	@corpus
	
	def initialize(text)
		@corpus = {}
		set = text.split
		set.each_index do |i|
			if i < set.length - 2 then addSet(set[i],set[i+1],set[i+2]) end
		end
	end
	
	def get(startWord, length)
		ret = ""
		word = startWord.split
		count = 0
		
		while @corpus.has_key? word and count < length
			newWord = @corpus[word][rand(@corpus[word].length)]
			ret << newWord + " " 
			word = [word[1],newWord]
			count += 1
		end
		
		ret
	end
	
	def addSet(key1, key2, value)
		@corpus.has_key?([key1,key2]) ? @corpus[[key1,key2]] << value : @corpus[[key1,key2]] = [value]
	end
	
	#def addText(text)
	#	set = text.split
	#	set.each_index do |i|
	#		if i < set.length - 1 then addSet(set[i],set[i+1]) end
	#	end
	#end
	
	def write
		f = File.new("quoths #{Time.new.to_s.gsub(/:/,"")}.txt", "w+")
		f << to_s
		f.close
	end
	
	def to_s
		ret = ""
		@corpus.each_pair do |key, value|
			ret << "[#{key[0].to_s},#{key[1].to_s}] => ["
			for word in value do ret << word + "," end
			ret.chop!
			ret << "], "
		end
		ret.chop.chop
	end
end