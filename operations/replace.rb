require_relative './operator'

module Replace
  extend Operator
  @@action = :replace

  def replace(remove_character, add_character)
    set_new_text_state(@current_text.gsub(remove_character, add_character))
    return nil
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
