require_relative './operator'

class Write
  def execute(builder, instruction)
    character_index = instruction.operand
    builder.current_text[character_index.to_i-1]
  end
end
