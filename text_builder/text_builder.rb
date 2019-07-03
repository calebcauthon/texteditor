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

    if instruction.operation.is_reversible?
      undo_queue.push(instruction.reverse(current_text))
    end

    instruction.operation.execute(self, instruction)
  end
end
