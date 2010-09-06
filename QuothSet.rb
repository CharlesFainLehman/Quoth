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

test = QuothSet.new("once upon a midnight dreary while I pondered weak and weary over many a quaint and curious volume of forgotten lore while I nodded nearly napping suddenly there came a tapping as of something gently wrapping wrapping at my chamber door tis some vistor I muttered tapping at my chamber door this it is and nothing more ah distinctly I remember it was in the bleak December and each separate dying ember wrought its ghost upon the floor eagerly I wished the morrow vainly I had sought to borrow from my books surcrease of sorrow sorrow for the lost lenore for the rare and radiant maiden who the angels named lenore nameless here forever more")
puts test
puts test.get("I",15)
test.write