require_relative './operator'

module Write
  extend Operator
  @@action = :print

  def write(character_index)
    get_character(character_index)
  end

  def get_character(character_index)
    @current_text[character_index.to_i-1]
  end

  def self.included(base)
    self.map_operator(base, @@action, lambda { |builder, instruction| builder.write instruction.operand })
  end
end
