$ALPHABET_LENGTH = 26
$LOWERCASE_A_INT = "a".ord

def letter_to_num(letter)
  return letter.ord - $LOWERCASE_A_INT
end

def num_to_letter(number)
  return (number + $LOWERCASE_A_INT).chr()
end

class Node
  attr_reader :childrenCount, :children
  def initialize()
    @children = Array.new($ALPHABET_LENGTH)
    @isTerminal = false
    @childrenCount = 0
  end

=begin
  insert(word)
  Paramters:
    word
      String to be inserted
  Returns:
    True if the word is successfully inserted
    False if the word is already in the trie

  The insert method is a recursion where we insert the word letter by letter. We achieve this by
  looking at the first letter, then removing it, shaving the word down by one letter at each
  iteration. There are 2 cases when performing the recursion:

  Case 1:
  The string is empty
    This means that we are the last node, and we thus turn ourselves into a terminal node by changing
    the boolean value, and we return true. If we are already a terminal node, we return false.

  Case 2:
  The string is not empty
  1)  Take the first letter from the word, find the letters number (a=0, b=1, c=2 ...)
  2)  Cut the first letter out of the word
  3)  Pass the trimmed word onto the child node which corresponds to the first letter which we
      removed (if the node does not exist, we have to make it)

  For example, if the word is "area":
    We pass the word "rea" to our first child
    That child then passes "ea" to its 18th child
    That child then passes "a" to the 5th child
    We then pass an empty string to the 1st child
=end
  def insert(wordInsert)
    if wordInsert.size == 0
      if @isTerminal == true
        return false
      end
      @isTerminal = true 
      return true
    end
    #1) Take first letter of the word, convert it to a number
    characterNumber = letter_to_num(wordInsert[0])

    #2) Remove the first letter from the word
    wordInsert.slice!(0)

    #3) Check children node, pass the trimmed word into the node
    if @children[characterNumber] == nil
      @children[characterNumber] = Node.new
      @childrenCount += 1
    end

    return @children[characterNumber].insert(wordInsert)
  end

=begin
  member(word)
  Paramters:
    word
      String to be checked
  Returns:
    True if the word is in the trie
    False otherwise

  The recursion for this function works similar to insert, but instead of inserting a word, we
  perform a read-only operation.

  To check for a word, we:
  1)  If the word is empty, the word has been completely read. Check if we are a terminal node
      If we are a terminal node, then that means that the word is saved in the trie
  2)  We have a character, we pass the function to the corresponding child with logic similar to
      insert. Then we have the following cases:
    2a) The node corresponding to the character is nil. We return false
    2b) The node exists, pass the function
=end
  def member(word)
    #1) The word is empty, check if we are a terminal node
    if word.size == 0
      if @isTerminal == true
        return true
      end
      return false
    end

    #2) Take the first letter, and shave it off of the word
    characterNumber = letter_to_num(word[0])
    word.slice!(0)

    #2a)
    if @children[characterNumber] == nil
      return false
    end

    #2b)
    return @children[characterNumber].member(word)
  end

=begin
  erase(word)
  Paramters:
    word
      The word which we wish to remove
  Returns:
    True if the word was successfully removed
    False otherwise (perhaps the word didn't exist?)

  Recursively follow the word until we reach the end node. If any node along the path does not have
  any children, then we make that node delete itself.

  2 cases:
  Case 1:
  We are at the end of the word. 
  1)  Check if our terminal bool is set, it should be
  2)  Set it correctly
  3)  Return true or false according to step 1

  Case 2:
  We are not at the end of the word.
  1)  Attempt to pass the word down the chain, return false if unable
  2)  If the function returned true, try to delete the child
  3)  Check the number of children it has. If it's 0, delete it
=end
  def erase(word)
    # Case 1:
    if word.size() == 0
      if @isTerminal == true
        @isTerminal = false
        return true
      else
        return false
      end
    end

    #Case 2:
    characterNumber = letter_to_num(word[0])
    word.slice!(0)

    #1)
    if @children[characterNumber] == nil
      return false
    else
      #2)
      ret = @children[characterNumber].erase(word)
      if ret
        #3)
        if @children[characterNumber].childrenCount == 0
          @children[characterNumber] = nil
          @childrenCount -= 1
        end
      end
      return ret
    end
  end

=begin
  check_partial(partialWord)
  Parameters:
    partialWord
      The partial word which we wish investigate further
  Returns:
    True, if the partial word could legitimately lead to being a word i.e. "ar" can lead to "area"
    False, if the partial word has a 0% chance of forming a word i.e. "zz" doesn't lead to anything

  To check the partial word, we use recursion with the following cases:
  Case 1: We have reached the end of the partial word
  1)  Check if we have children
  2)  Check if we are a terminal node

  Case 2: We are not at the end of the partial word
  1)  Pass it down recursively
=end
  def check_partial(partialWord)
    #Case 1
    if partialWord.size() == 0
      if @childrenCount > 0 || @isTerminal == true
        return true
      else
        return false
      end
    end

    #Case 2
    characterNumber = letter_to_num(partialWord[0])
    partialWord.slice!(0)
    if @children[characterNumber] == nil
      return false
    end
    return @children[characterNumber].check_partial(partialWord)
  end
end

