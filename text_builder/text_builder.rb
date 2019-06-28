require_relative './instruction_parser'

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