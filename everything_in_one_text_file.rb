module Operator
  def map_operator text_builder_class, operator, action
    text_builder_class.operator_map[operator] = action
  end
end

module Append
  extend Operator

  def append text
    set_new_text_state "#{@current_text}#{text}"
    return
  end

  def reverse_append instruction
    original_instruction = instruction.operand
    character_count = original_instruction.operand.size
    @current_text = @current_text[0...(-1 * character_count)]
    return
  end

  def self.included(base)
    self.map_operator base, :append, lambda { |builder, instruction| builder.append instruction.operand }
    self.map_operator base, :reverse_append, lambda { |builder, instruction| builder.reverse_append instruction }
  end
end

module Delete
  extend Operator
  @@action = :delete

  def delete character_count, instruction
    start = current_text.size-instruction.operand.to_i
    the_end = current_text.size-1
    characters_to_delete = current_text[start..the_end]
    track_reversal instruction, characters_to_delete
    set_new_text_state @current_text[0...(-1 * character_count)]
    return
  end

  def reversal_map
    @reversal_map = Hash.new unless @reversal_map
    @reversal_map
  end

  def track_reversal instruction, characters_removed
    reversal_map[instruction] = characters_removed
  end

  def reverse_delete original_instruction
    characters_removed = @reversal_map[original_instruction]
    set_new_text_state @current_text.concat(characters_removed)
    return
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.delete instruction.operand.to_i, instruction }
    self.map_operator base, :reverse_delete, lambda { |builder, instruction| builder.reverse_delete instruction.operand }
  end
end


module Replace
  extend Operator
  @@action = :replace

  def replace remove_character, add_character
    set_new_text_state @current_text.gsub(remove_character, add_character)
    return nil
  end

  def reverse_replace reversal_instruction
    original_instruction = reversal_instruction.operand
    replace original_instruction.operand[2], original_instruction.operand[0]
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.replace(instruction.operand[0], instruction.operand[2]) }
    self.map_operator base, :reverse_replace, lambda { |builder, instruction| builder.reverse_replace instruction }
  end
end

module Undo
  extend Operator
  @@action = :undo

  def undo
    undo_instruction = undo_queue.pop
    operate undo_instruction
    return
  end

  def undo_queue
    @undo_queue = [] unless @undo_queue
    @undo_queue
  end

  def save_previous_state text, instruction
    undo_queue.push instruction.reverse(current_text) if instruction.reverse(current_text)
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.undo }
    hook = lambda { |builder, old_text, new_text, instruction| builder.save_previous_state old_text, instruction }
    base.on_before_new_text_state.push hook
  end
end

module Write
  extend Operator
  @@action = :print

  def write character_index
    character = get_character character_index
    return character
  end

  def get_character character_index
    @current_text[character_index.to_i-1]
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.write instruction.operand }
  end
end
class Instruction
  attr_accessor :operation
  attr_accessor :operand
  attr_accessor :raw

  def load_from_text instruction_line
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
    @raw = instruction_line
  end

  def disable_reversal
    @reverse_disabled = true
  end

  def reverse current_text
    return if @reverse_disabled

    instruction = Instruction.new
    instruction.operation = "reverse_#{@operation.to_s}".to_sym
    instruction.operand = self
    instruction.disable_reversal
    instruction
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
      instruction = Instruction.new
      instruction.load_from_text instruction_line
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
    @current_instruction = instruction

    output = @@operator_map[instruction.operation].call self, instruction if @@operator_map[instruction.operation]

    output
  end

  def set_new_text_state text
    @@on_before_new_text_state.each { |hook| hook.call(self, self.current_text, text, @current_instruction) }
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


def text_editor instruction_text
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load instruction_text

  output = ''
  count = 1
  instructions.each do |instruction|
    count = count + 1
    new_output = text_state.operate instruction

    if output.size > 0 and new_output and new_output.size > 0
      output << "\n#{new_output}"
    elsif new_output and new_output.size > 0 and output == ''
      output = new_output
    end
  end

  output
end

user_input = (STDIN.tty?) ? 'not reading from stdin' : $stdin.read

puts text_editor(user_input)
