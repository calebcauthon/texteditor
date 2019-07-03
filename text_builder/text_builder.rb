require_relative './instruction_parser'

class TextBuilder
  attr_accessor :current_text

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

    if [:print, :delete, :append, :replace].include?(instruction.operation) or ['ReplaceUndo', 'AppendUndo'].include?(instruction.operation_class.class.name)
      output = instruction.operation_class.execute(self, instruction)
    else
      output = @@operator_map[instruction.operation].call self, instruction if @@operator_map[instruction.operation]
    end

    output
  end

  def set_new_text_state text
    @@on_before_new_text_state.each { |hook| hook.call(self, self.current_text, text, @current_instruction) }
    @current_text = text
  end

  include Undo
  include Write
  include DeleteMixin
end
