require 'require_all'
require_all './operations'

def text_editor instruction_text
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load instruction_text

  output = ''

  instructions.each do |instruction|
    new_output = text_state.operate instruction
    output = "#{output}#{new_output}"
  end

  output
end

class Instruction
  attr_accessor :operation
  attr_accessor :operand

  def initialize instruction_line
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = :undo
    when '3'
      @operation = :print
    when '2'
      @operation = :delete
    when '1'
      @operation = :append
    when '5'
      @operation = :replace
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
  end
end

class InstructionParser
  def load text
    all_lines = text.split(/\n/)
    @instruction_lines = all_lines.slice(1..all_lines.size-1)
    @index = 0
  end

  def each
    return nil unless @instruction_lines.at(@index)

    @instruction_lines.each do |instruction_line|
      instruction = Instruction.new instruction_line
      yield instruction
    end
  end
end

class TextBuilder
  @@operator_map = Hash.new
  def self.operator_map
    @@operator_map
  end

  @@on_before_new_text_state = Array.new

  def initialize
    @current_text = ''
  end

  def self.on_before_new_text_state
    @@on_before_new_text_state
  end

  def operate instruction
    @@operator_map[instruction.operation].call self, instruction
  end

  def set_new_text_state text
    @@on_before_new_text_state.each { |hook| hook.call(self, text) }
    @current_text = text
  end

  def current_text
    @current_text
  end

  include Append
  include Undo
  include Write
  include Delete
  include Replace
end
