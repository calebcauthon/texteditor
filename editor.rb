require 'require_all'
require_all './operations'
require './text_builder/text_builder'

def text_editor instruction_text
  text_state = TextBuilder.new
  instructions = InstructionParser.new
  instructions.load instruction_text

  output = ''
  count = 1
  instructions.each do |instruction|
    count = count + 1
    new_output = text_state.operate instruction

    if output.size > 0 and new_output and new_output.size > 0
      output = "#{output}\n#{new_output}"
    elsif new_output and new_output.size > 0 and output == ''
      output = new_output
    end
  end

  output
end
