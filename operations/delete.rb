require_relative './operator'

module Delete
  extend Operator
  @@action = :delete

  def delete character_count
    set_new_text_state @current_text[0...(-1 * character_count)]
    return
  end

  def self.included(base)
    self.map_operator base, @@action, lambda { |builder, instruction| builder.delete instruction.operand.to_i }
  end
end
