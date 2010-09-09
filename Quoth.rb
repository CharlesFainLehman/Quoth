require "time"
require "yaml"

#A class which constructs semi-realistic sentences based on a markov-chain algorithm.
#wraps a hash which has keys which are arrays of length 2 containing two words and values which are arrays containing all third words associated with those two words. For example:
#	["I","am"] => ["Sam", "Ham", "Eggs"]
#the corpus is constructed from any large block of text- words are organized by sets of two and then have the word following them associated with them. The corpus can also be constructed from a previously generated .yaml file created by the to_yaml() method.
#When accessing the corpus, the get method looks at a string of two words (for example "I am"), splits it and then uses the resultant array as the key. The value is tacked on to the end of the first string, and the second word in the string ("am") is used alongside the retrieved value as a new key. This exercise is repeated until a certain length has been achieved.
class Quoth
	#the main corpus- contains sets of words and their associated next words.
	attr_reader :corpus
	
	#Accepts a .txt, a .yaml or just straight text
	def initialize(text)
		@corpus = {}
		add text
	end
	
	#returns a sentence beginning with startWord and of length length + 1
	def get(startWord, length)
		ret = startWord + " "
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
	
	#a general method for adding a .txt, a .yaml, straight text or a [key,key] => value to the corpus
	#If adding something besides [key,key] => value, just pass an argument for key1
	def add(key1,key2="",value="")
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
		
	#merges the current corpus with the corpus of the other quoth
	def merge(oQuoth)
		return if !oQuoth.is_a?(Quoth)
		oQuoth.corpus.each_pair do |key, value|
			for val in value do
				add key[0], key[1], val
			end
		end
	end
	
	#converts the corpus to a string representation for printing
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
	
	#Writes the corpus to yaml- may take a while for large corpuses
	def to_yaml(fileName="")
		if fileName != "" then
			File.open(fileName, 'w') do |f|
				YAML.dump(@corpus,f)
			end
		else
			YAML.dump(@corpus)
		end
	end
	
	#loads from yaml into the corpus
	def load_yaml(fileName)
		temp = YAML.load_file fileName
		temp.each_pair do |key, value|
			for val in value do
				add key[0], key[1], val
			end
		end
	end
end