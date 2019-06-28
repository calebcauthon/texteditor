class Instruction
  attr_accessor :operation
  attr_accessor :operand

  def initialize instruction_line
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = :undo
    when '3'
      @operation = :print
    when '2'
      @operation = :delete
    when '1'
      @operation = :append
    when '5'
      @operation = :replace
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
  end
end