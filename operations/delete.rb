class Delete
  attr_accessor :characters_removed

  def is_reversible?
    true
  end

  def execute(builder, instruction)
    character_count = instruction.operand.to_i
    first = builder.current_text.size-instruction.operand.to_i
    last = builder.current_text.size-1
    characters_to_delete = builder.current_text[first..last]
    builder.current_text = builder.current_text[0...(-1 * character_count)]

    @characters_removed = characters_to_delete
    nil
  end

  def undo
    DeleteUndo.new
  end
end

class DeleteUndo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    characters_removed = instruction.operand.operation.characters_removed
    builder.current_text = builder.current_text.concat(characters_removed)
    nil
  end
end
