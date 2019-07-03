require_relative './instruction'

class InstructionParser
  attr_accessor :instruction_lines

  def load text
    all_lines = text.split(/\n/)
    @instruction_lines = all_lines.slice(1..all_lines.size-1)
  end
end
