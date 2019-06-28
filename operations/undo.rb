require_relative './operator'

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
