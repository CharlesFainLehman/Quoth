require "time"
require "yaml"

class Quoth
	attr_reader :corpus
	
	def initialize(text)
		@corpus = {}
		add text
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
	
	def add(key1,key2="",value="") #key1 can actually be anything, and has multiple uses
		if !(key2 == "" and value == "") then
			@corpus.has_key?([key1,key2]) ? @corpus[[key1,key2]] << value : @corpus[[key1,key2]] = [value]
		elsif /[\w|\W]*?\.yaml/ =~ key1 then
			load_yaml key1
		elsif /[\w|\W]*?\.txt/ =~ key1 then
			File.open(key1) do |f| add(f.read) end
		elsif key1.instance_of? String then
			set = key1.split
			set.each_index do |i|
				if i < set.length - 2 then add(set[i],set[i+1],set[i+2]) end
			end
		end
	end
		
	def merge(oQuoth)
		return if !oQuoth.is_a?(Quoth)
		oQuoth.corpus.each_pair do |key, value|
			for val in value do
				add key[0], key[1], val
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
	
	def load_yaml(fileName)
		temp = YAML.load_file fileName
		temp.each_pair do |key, value|
			for val in value do
				add key[0], key[1], val
			end
		end
	end
end