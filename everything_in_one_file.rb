class Append
  def is_reversible?
    true
  end

  def execute(builder, instruction)
    text = instruction.operand
    builder.current_text = "#{builder.current_text}#{text}"
    nil
  end

  def undo
    AppendUndo.new
  end
end

class AppendUndo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    original_instruction = instruction.operand
    character_count = original_instruction.operand.size
    builder.current_text = builder.current_text[0...(-1 * character_count)]
    nil
  end
end

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

class Replace
  def is_reversible?
    true
  end

  def execute(builder, instruction)
    remove_character = instruction.operand[0]
    add_character = instruction.operand[2]
    builder.current_text = builder.current_text.gsub(
      remove_character,
      add_character)
    nil
  end

  def undo
    ReplaceUndo.new
  end
end

class ReplaceUndo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    reversal_instruction = instruction
    original_instruction = reversal_instruction.operand
    remove_character = original_instruction.operand[2]
    add_character = original_instruction.operand[0]
    builder.current_text = builder.current_text.gsub(
      remove_character,
      add_character)
  end
end

class Undo
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    undo_instruction = builder.undo_queue.pop
    builder.operate(undo_instruction)
    nil
  end
end

class Write
  def is_reversible?
    false
  end

  def execute(builder, instruction)
    character_index = instruction.operand
    builder.current_text[character_index.to_i-1]
  end
end

class Instruction
  attr_accessor :operation
  attr_accessor :operand
  attr_accessor :raw

  def load_from_text(instruction_line)
    operator = instruction_line.slice(0)

    case operator
    when '4'
      @operation = Undo.new
    when '3'
      @operation = Write.new
    when '2'
      @operation = Delete.new
    when '1'
      @operation = Append.new
    when '5'
      @operation = Replace.new
    end

    @operand = instruction_line.slice(2..instruction_line.size-1)
    @raw = instruction_line
  end

  def reverse current_text
    instruction = Instruction.new
    instruction.operation = self.operation.undo
    instruction.operand = self
    instruction
  end
end

class InstructionParser
  attr_accessor :instruction_lines

  def load text
    all_lines = text.split(/\n/)
    @instruction_lines = all_lines.slice(1..all_lines.size-1)
  end
end

class TextBuilder
  attr_accessor :current_text
  attr_accessor :undo_queue

  def initialize
    @current_text = ''
    @undo_queue = [] unless @undo_queue
  end

  def operate instruction
    @current_instruction = instruction

    if instruction.operation.is_reversible?
      undo_queue.push(instruction.reverse(current_text))
    end

    instruction.operation.execute(self, instruction)
  end
end

#!/usr/bin/env ruby
require_relative './editor'

user_input = (STDIN.tty?) ? 'not reading from stdin' : $stdin.read

puts text_editor(user_input)
