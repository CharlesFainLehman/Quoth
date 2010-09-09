require "time"
require "yaml"

class Quoth
	attr_reader :corpus
	
	def initialize(text)
		@corpus = {}
		if /[\w|\W]*?\.yaml/ =~ text and File.exists? text then
			from_yaml(text)
		elsif /[\w|W]*?\.txt/ =~ text and File.exists? text then
			File.open(text) do |f| addText(f.read) end
		else
			addText(text)
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
	
	def addText(text)
		set = text.split
		set.each_index do |i|
			if i < set.length - 2 then addSet(set[i],set[i+1],set[i+2]) end
		end
	end
	
	def merge(oQuoth)
		return if !oQuoth.is_a?(Quoth)
		oQuoth.corpus.each_pair do |key, value|
			for val in value do
				addSet key[0], key[1], val
			end
		end
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
	
	def to_yaml(fileName="")
		if fileName != "" then
			File.open(fileName, 'w') do |f|
				YAML.dump(@corpus,f)
			end

		else
			YAML.dump(@corpus)
		end
	end
	
	def from_yaml(fileName)
		@corpus = YAML.load_file fileName
	end
end