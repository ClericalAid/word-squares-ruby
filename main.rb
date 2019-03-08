require_relative 'trie.rb'
require 'pry'

#Word square is a string array
=begin
  The word is so many letters long. For each letter, we need to check that each column forms
  a coherent word
=end
def check_word_square(wordSquare, dictionary)
  for i in 0...wordSquare[0].size
    stringToCheck = String.new
    for j in 0...wordSquare.size
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
for i in 0...$WORD_LENGTH-1
  trieArray.push(Trie.new)
end

#binding.pry
dictionaryFile.each_line do |word|
  word = word.strip()
  dictionaryTrie.insert(word.dup)
  for i in 0...$WORD_LENGTH-1
    trieArray[i].insert(word.dup)
  end
end

=begin
puts dictionaryTrie.member("mind")
for i in 0...$WORD_LENGTH-1
  puts trieArray[i].member("mind")
end
=end

stringArray = Array.new
puts "Enter a 4 letter word"
stringArray.push(gets.chomp)

#binding.pry

=begin
  How to effectively add 3 words to the word square?
  
  Try to get the 1st word:
  look through the trie
  Check that it might work
  Found one that might work, try to move on:
    Loop for the second word (similar to 1st loop)
  We exited the loop and don't have a good square yet, go again

  FOR LOOP?
    While the word square is not valid
      Get the next word, check that it's not boolean false
      put that word into the square
      check the square
      remove the word if it does not create a valid square, move on otherwise
    While (search for word)
      Check the word according to depth (verify first 2 or 3 letters)
      It works
    Increment depth by 1 (we are going one deeper now)
=end
currentDepth = 0
while stringArray.size < $WORD_LENGTH
  for depth in currentDepth...$WORD_LENGTH-1
    validWordSquare = false
    while !validWordSquare
      nextWord = trieArray[depth].get_next_word()
      if nextWord == false
        puts stringArray
        puts
        stringArray.pop
        currentDepth = depth - 1
        break
      end
      if nextWord == nil
        puts "wtf"
      end
      stringArray.push(nextWord)

      validWordSquare = check_word_square(stringArray, dictionaryTrie)
      if (!validWordSquare)
        stringArray.pop
      end
    end
  end

  while stringArray.size!= $WORD_LENGTH && stringArray.size > currentDepth+1
    stringArray.pop
  end

  if currentDepth == -1
    puts "No word square found"
    break
  end
end

for i in 0...$WORD_LENGTH
  puts "#{stringArray[i]}"
end
