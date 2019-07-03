require 'require_all'
require_all './operations'
require './text_builder/text_builder'

def text_editor(instruction_text)
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load(instruction_text)

  instructions.instruction_lines.inject '' do |output, instruction_text|
    instruction = Instruction.new
    instruction.load_from_text instruction_text

    new_output = text_state.operate instruction

    if new_output && new_output.size > 0
      append_to_output(output, new_output)
    else
      output
    end
  end
end

def append_to_output(output, new_output)
  if output.size > 0
    output << "\n#{new_output}"
    return output
  elsif output == ''
    return new_output
  end
end
