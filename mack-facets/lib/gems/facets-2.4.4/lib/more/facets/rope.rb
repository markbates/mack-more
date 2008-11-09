require "rubygems"
require "facets/kernel/returning"
require "facets/symbol/to_proc"

#class String
#  def shift
#    return nil if empty?
#    returning self[0].chr do
#      self[0] = ""
#    end
#  end
#end

# = Rope Class
#
class Rope
  attr_reader :left, :right, :length

  def Rope.new(*args)
    if args.size <= 2
      super
    else # build balanced tree
      mid = args.size / 2
      args[mid,2] = Rope.new(*args[mid,2])
      Rope.new(*args)
    end
  end

  def initialize(left="",right="")
    @left, @right = left, right
    @length = @left.length + @right.length
  end

  def replace(rope)
    initialize(rope.left,rope.right)
    self
  end

  # clean out empty strings and rebuild tree
  def normalize
    Rope.new(*flat_strings.reject(&:empty?))
  end

  def to_s
    @left.to_s + @right.to_s
  end

  def append(str)
    Rope.new(self,str)
  end
  alias_method :<<, :append
  alias_method :+, :append

  def prepend(str)
    Rope.new(str,self)
  end

  def slice(start,length=@length-start)
    if start > left.length # right
      right.slice(start-left.length,length-left.length)
    elsif left.length < length # left and right
      left.slice(start,left.length) +
      right.slice(start-left.length,length-left.length)
    else # left
      left.slice(start,length)
    end
  end

  def shift
    if letter = string_shift(left) || string_shift(right)
      @length -= 1
      letter
    else
      nil
    end
  end

  def index(letter,start=0)
    if start > left.length # right
      left.length + right.index(letter,start - left.length)
    else # left
      left.index(letter,start) || left.length + right.index(letter)
    end
  rescue
    nil
  end

  # TODO implement rest of methods
  def method_missing(method, *args, &block)
    (@method_missing_stack ||= []) << method
    if @method_missing_stack[-2] == @method_missing_stack[-1]
      raise "recursive method missing -- #{method}"
    end
    result = to_s.send(method, *args, &block)
    if result.is_a?(String)
      if method.to_s =~ /!$/
        replace(Rope.new(result))
      else
        Rope.new(result)
      end
    else
      result
    end
  end

protected

  # traverse the tree
  def traverse(&block)
    @left.is_a?(Rope) ? @left.traverse(&block) : block.call(@left)
    @right.is_a?(Rope) ? @right.traverse(&block) : block.call(@right)
  end

  # collect all the flat strings
  def flat_strings
    ary = []
    traverse { |str| ary << str }
    ary
  end

private 

  def string_shift(str)
    return nil if str.empty?
    returning str[0].chr do
      str[0] = ""
    end
  end

end

