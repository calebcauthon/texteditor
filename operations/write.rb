class Write
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    character_index = instruction.operand
    builder.current_text[character_index.to_i-1]
  end
end
