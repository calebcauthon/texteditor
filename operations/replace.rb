require_relative './operator'

class Replace
  def is_reversible?
    true
  end

  def execute(builder, instruction)
    remove_character = instruction.operand[0]
    add_character = instruction.operand[2]
    builder.current_text = builder.current_text.gsub(remove_character, add_character)
    nil
  end

  def undo
    ReplaceUndo.new
  end
end

class ReplaceUndo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    reversal_instruction = instruction
    original_instruction = reversal_instruction.operand
    remove_character = original_instruction.operand[2]
    add_character = original_instruction.operand[0]
    builder.current_text = builder.current_text.gsub(remove_character, add_character)
  end
end
