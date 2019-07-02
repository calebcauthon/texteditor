require_relative './operator'

module Delete
  extend Operator
  @@action = :delete

  def delete(character_count, instruction)
    start = current_text.size-instruction.operand.to_i
    the_end = current_text.size-1
    characters_to_delete = current_text[start..the_end]
    track_reversal instruction, characters_to_delete
    set_new_text_state @current_text[0...(-1 * character_count)]
    return
  end

  def reversal_map
    @reversal_map = Hash.new unless @reversal_map
    @reversal_map
  end

  def track_reversal(instruction, characters_removed)
    reversal_map[instruction] = characters_removed
  end

  def reverse_delete(original_instruction)
    characters_removed = @reversal_map[original_instruction]
    set_new_text_state @current_text.concat(characters_removed)
    return
  end

  def self.included(base)
    self.map_operator(base, @@action, lambda { |builder, instruction| builder.delete instruction.operand.to_i, instruction })
    self.map_operator(base, :reverse_delete, lambda { |builder, instruction| builder.reverse_delete instruction.operand })
  end
end
