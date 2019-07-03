require_relative './operator'

class Append
  def is_reversible?
    true
  end

  def execute(builder, instruction)
    text = instruction.operand
    builder.set_new_text_state("#{builder.current_text}#{text}")
    nil
  end

  def undo
    AppendUndo.new
  end
end

class AppendUndo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    original_instruction = instruction.operand
    character_count = original_instruction.operand.size
    builder.current_text = builder.current_text[0...(-1 * character_count)]
    nil
  end
end
