def text_editor instructions
  if instructions.length > 0
    operation = instructions.slice(1)
    text = instructions.slice(2..instructions.length-1)

    return text
  end

  ''
end