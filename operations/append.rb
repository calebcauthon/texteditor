require_relative './operator'

module Append
  extend Operator

  def append(text)
    set_new_text_state("#{@current_text}#{text}")
    nil
  end

  def reverse_append(instruction)
    original_instruction = instruction.operand
    character_count = original_instruction.operand.size
    @current_text = @current_text[0...(-1 * character_count)]
    nil
  end

  def self.included(base)
    execute_append_instruction = -> (builder, instruction) {
      builder.append instruction.operand
    }
    self.map_operator(base, :append, execute_append_instruction)

    execute_reverse_append_instruction = -> (builder, instruction) {
      builder.reverse_append instruction
    }
    self.map_operator(
      base,
      :reverse_append,
      execute_reverse_append_instruction
    )
  end
end
