require_relative './operator'

module Replace
  extend Operator
  @@action = :replace

  def replace remove_character, add_character
    set_new_text_state @current_text.gsub(remove_character, add_character)
    return nil
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.replace(instruction.operand[0], instruction.operand[2]) }
  end
end
