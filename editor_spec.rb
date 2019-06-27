require_relative 'editor'

describe 'text editor' do
  it 'returns a blank string if there are no instructions' do
    instructions = ''
    result = text_editor(instructions)
    expect(result).to eq('')
  end
end
