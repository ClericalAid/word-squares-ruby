require_relative 'trie.rb'
require 'pry'

$DICTIONARY = "4-letter-words.txt"
dictionaryTrie = Trie.new

dictionaryFile = File.open($DICTIONARY, "r")

dictionaryFile.each_line do |word|
  word = word.strip()
  dictionaryTrie.insert(word)
end

puts "#{dictionaryTrie.check_partial("mind")}"
puts "#{dictionaryTrie.check_partial("idea")}"
puts "#{dictionaryTrie.check_partial("mi")}"
puts "#{dictionaryTrie.check_partial("id")}"
puts "#{dictionaryTrie.check_partial("ne")}"
puts "#{dictionaryTrie.check_partial("da")}"
#binding.pry
for i in 0..4022
  dictionaryTrie.get_next_word()
end
for i in 0..20
  puts "#{dictionaryTrie.get_next_word()}"
end
puts "Enter a 4 letter word"
userWord = gets.chomp
puts "#{dictionaryTrie.member(userWord)}"

