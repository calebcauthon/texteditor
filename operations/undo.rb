class Undo
  def is_reversible?
    false
  end

  def execute builder, instruction
    undo_instruction = builder.undo_queue.pop
    builder.operate undo_instruction
    nil
  end
end
