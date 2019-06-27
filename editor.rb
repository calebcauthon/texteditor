def text_editor instructions
  previous_states = []
  instruction_lines = instructions.split(/\n/)
  first_line = instruction_lines.first

  text = ''
  if instruction_lines.size > 1

    instruction_lines.slice(1..instruction_lines.size-1).each do |instruction_line|
      operation = instruction_line.slice(0)
      if operation == '4'
        text = previous_states.pop
      else
        previous_states.push text
        text_to_append = instruction_line.slice(2..instruction_line.size-1)
        text = "#{text}#{text_to_append}"
      end
    end
  end

  text
end