require_relative './instruction_parser'

class TextBuilder
  attr_accessor :current_text
  attr_accessor :undo_queue

  @@operator_map = Hash.new
  def self.operator_map
    @@operator_map
  end

  @@on_before_new_text_state = Array.new

  def initialize
    @current_text = ''
    @undo_queue = [] unless @undo_queue
  end

  def operate instruction
    @current_instruction = instruction

    if instruction.operation == :undo
      undo
    else
      if instruction.operation_class.is_reversible?
        undo_queue.push instruction.reverse(current_text)
      end
      output = instruction.operation_class.execute(self, instruction)
    end

    output
  end

  def undo
    undo_instruction = undo_queue.pop
    operate undo_instruction
    nil
  end
end
