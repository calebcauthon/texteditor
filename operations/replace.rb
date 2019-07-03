require_relative './operator'

class Replace
  def execute(builder, instruction)
    remove_character = instruction.operand[0]
    add_character = instruction.operand[2]
    builder.set_new_text_state(builder.current_text.gsub(remove_character, add_character))
    nil
  end

  def undo
    ReplaceUndo.new
  end
end

class ReplaceUndo
  def execute(builder, instruction)
    reversal_instruction = instruction
    original_instruction = reversal_instruction.operand
    remove_character = original_instruction.operand[2]
    add_character = original_instruction.operand[0]
    builder.set_new_text_state(builder.current_text.gsub(remove_character, add_character))
  end
end

module ReplaceMixin
  extend Operator
  @@action = :replace

  def replace(remove_character, add_character)
    set_new_text_state(@current_text.gsub(remove_character, add_character))
    nil
  end

  def reverse_replace(reversal_instruction)
    original_instruction = reversal_instruction.operand
    replace(original_instruction.operand[2], original_instruction.operand[0])
  end

  def self.included(base)
    self.map_operator(base, @@action, lambda { |builder, instruction| builder.replace(instruction.operand[0], instruction.operand[2]) })
    self.map_operator(base, :reverse_replace, lambda { |builder, instruction| builder.reverse_replace instruction })
  end
end
