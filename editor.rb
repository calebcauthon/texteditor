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
    when '1'
      @operation = :append
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

module Operator
  def map_operator text_builder_class, operator, action
    text_builder_class.operator_map[operator] = action
  end
end

module Append
  extend Operator

  def append text
    @previous_states.push @current_text
    @current_text = "#{@current_text}#{text}"

    return
  end

  def self.included(base)
    self.map_operator base, :append, lambda { |builder, instruction| builder.append instruction.operand }
  end
end

module Undo
  extend Operator
  @@action = :undo

  def undo
    @current_text = @previous_states.pop
    return
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.undo }
  end
end

module GetCharacter
  def get_character character_index
    @current_text[character_index.to_i-1]
  end
end

module Write
  def write instruction
    character_index = instruction.operand
    character = get_character character_index
    return "#{character}\n"
  end
end

class TextBuilder
  @@operator_map = Hash.new
  def self.operator_map
    @@operator_map
  end

  include Append
  include Undo
  include GetCharacter
  include Write

  def initialize
    @current_text = ''
    @previous_states = []
  end

  def operate instruction
    if instruction.operation == :undo
      @@operator_map[:undo].call self, instruction
    elsif instruction.operation == :print
      write instruction
    else
      @@operator_map[:append].call self, instruction
    end
  end

  def current_text
    @current_text
  end
end