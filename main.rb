require_relative 'trie.rb'
require 'pry'

#Word square is a string array
=begin
  The word is so many letters long. For each letter, we need to check that each column forms
  a coherent word
=end
def check_word_square(wordSquare, dictionary, depth)
  for i in 0...wordSquare[0].size
    stringToCheck = String.new
    for j in 0..depth
      stringToCheck << wordSquare[j][i]
    end

    if (!dictionary.check_partial(stringToCheck))
      return false
    end
  end
  return true
end

$DICTIONARY = "4-letter-words.txt"
#$DICTIONARY = "word-squares.txt"
$WORD_LENGTH = 4

dictionaryFile = File.open($DICTIONARY, "r")
dictionaryTrie = Trie.new

#4 Tries for each word in the square
trieArray = Array.new
for i in 0...$WORD_LENGTH
  trieArray.push(Trie.new)
end

#binding.pry
dictionaryFile.each_line do |word|
  word = word.strip()
  dictionaryTrie.insert(word.dup)
  for i in 0...$WORD_LENGTH
    trieArray[i].insert(word.dup)
  end
end

for i in 0...$WORD_LENGTH
  trieArray[i].check_partial("mi")
end

# We keep track of which words need to be changed in our square. The first word is locked
changeWord = Array.new($WORD_LENGTH, true)
changeWord[0] = false
wordSquare = Array.new($WORD_LENGTH)
validWordSquare = false

puts "Enter a 4 letter word"
wordSquare[0] = gets.chomp



=begin
A while loop that goes on until we exhaust all possible combinations, and are forced to change
the first word

Then we have a for loop which changes the word at each layer.
  If we never find a word, it means that the word above us needs to change

  If we find a word that works, we lock it in and move onto the next layer

If one layer reaches the last word, it tells the layer above it to change its word. This gives us
the depth-first search approach.
=end
#binding.pry
while changeWord[0] == false
#puts wordSquare
#puts
  for i in 1...$WORD_LENGTH
    while changeWord[i] == true
      nextWord = trieArray[i].get_next_word()
      if nextWord == false
        changeWord[i] = true
        changeWord[i-1] = true
        break
      end
      wordSquare[i] = nextWord.dup

      if (check_word_square(wordSquare, dictionaryTrie, i))
        changeWord[i] = false
      end
    end
  end
  if changeWord[$WORD_LENGTH-1] == false
    puts wordSquare
    puts
  end
  # Hard code this so that the word square never thinks hes complete
  changeWord[$WORD_LENGTH-1] = true
end
#binding.pry

=begin


for i in 0...$WORD_LENGTH
  puts "#{wordSquare[i]}"
end
=end
