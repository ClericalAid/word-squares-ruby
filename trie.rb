require_relative 'node.rb'
class Trie
attr_reader :size
  def initialize
    @rootNode = Node.new
    @size = 0
    @wordStack = String.new
    @nodeStack = Array.new
    @nodeStack.push(@rootNode)
  end

  def member(word)
    passThisWord = word.dup
    @rootNode.member(passThisWord)
  end

  def insert(word)
    passThisWord = word.dup
    if @rootNode.insert(passThisWord)
      @size += 1
    end
  end

  def erase(word)
    passThisWord = word.dup
    ret = @rootNode.erase(passThisWord)
    if ret
      @size -= 1
    end
    return ret
  end

  def check_partial(partialWord)
    passThisWord = partialWord.dup
    return @rootNode.check_partial(passThisWord)
  end

  def reset_word()
    @wordStack = String.new
    @nodeStack = Array.new
    @nodeStack.push(@rootNode)
  end

=begin
TODO: Break this function down into multiple smaller functions. This is outrageous.
  get_next_word()
  Return: 
    The next word in the trie via depth-first search
  Traverses the trie in a depth first manner to exhaustively search through all of the words

  2 primary cases to deal with:
  Case 1: 
  We need to go up the tree and look for a new partial word 
  Condition: no children exist for our current node OR we have visited our last child 
  Stop when: we find a node where we can continue our search
    Pop the last node out
    Pop the last letter out
    Read the new, last node, and move onto its next child according to the last letter we popped


  Case 2:
  We need to go down the tree, and we have a node where we can start
    Do a while loop that goes depth-first:
    sub-case 1:
    We have no more children, we output the word

    sub-case 2: WE ARE NOT YET DEALING WITH THIS CASE
    We are a terminal node, output the word

    sub-case 3:
    We have children, go down the tree
    This breaks down into more cases (oh man)
    1)  First time visit
        Easy case, we go down the tree and just pick the first available child

    2)  Not the first visit
        We need to get the next child

    The logic is similar though:
    1)  Look for a child that is not nil, starting from 'a' going to 'z'
    2)  Place that letter into the word, push its corresponding node onto the stack
    3)  Take the next node, go to beginning of loop
=end
  def get_next_word()
    currentNode = @nodeStack.last
    currentLetter = 0
    visitedLastChild = false

    #Case 1: Proceed upwards
    while currentNode.childrenCount == 0 || visitedLastChild == true
      @nodeStack.pop
      currentNode = @nodeStack.last
      #We want to start searching for children at the next letter, not revisit the old nodes
      currentLetter = letter_to_num(@wordStack[@wordStack.length()-1]) + 1
      @wordStack.chop!

      visitedLastChild = true
      for i in currentLetter...$ALPHABET_LENGTH
        if currentNode.children[i] != nil
          currentLetter = i
          visitedLastChild = false
          break
        end
      end
      if currentNode == @rootNode && visitedLastChild == true
        return false
      end
    end

=begin
    if currentNode == @rootNode && visitedLastChild 
      return false
    end
=end

    #Case 2: We have children, go down the rabbit hole
    while currentNode.childrenCount > 0
      #1) Start looking for the next available letter starting from the letter we are currently at
      for i in currentLetter...$ALPHABET_LENGTH
        if currentNode.children[i] != nil
          break
        end
      end
      #Reset the current letter so we go back to 'a', always
      currentLetter = 0
      
      @nodeStack.push(currentNode.children[i])
      currentNode = currentNode.children[i]
      @wordStack << num_to_letter(i) 
    end
    return @wordStack
  end
end
