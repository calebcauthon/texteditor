def text_editor instructions
  previous_states = []
  instruction_lines = instructions.split(/\n/)
  first_line = instruction_lines.first

  text = ''
  output = ''
  if instruction_lines.size > 1

    instruction_lines.slice(1..instruction_lines.size-1).each do |instruction_line|
      operation = instruction_line.slice(0)
      if operation == '4'
        text = previous_states.pop
      elsif operation == '3'
        character_index = instruction_line.slice(2..instruction_line.size-1)
        text_to_write = text[character_index.to_i-1]
        output = "#{output}#{text_to_write}\n"
      else
        previous_states.push text
        text_to_append = instruction_line.slice(2..instruction_line.size-1)
        text = "#{text}#{text_to_append}"
      end
    end
  end

  output
end