require_relative './instruction_parser'

class TextBuilder
  attr_accessor :current_text
  attr_accessor :undo_queue

  def initialize
    @current_text = ''
    @undo_queue = [] unless @undo_queue
  end

  def operate instruction
    @current_instruction = instruction

    undo_queue.push instruction.reverse(current_text) if instruction.operation_class.is_reversible?
    instruction.operation_class.execute(self, instruction)
  end
end
