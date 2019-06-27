require_relative 'editor'

describe 'text editor' do
  describe 'single instructions' do
    it 'returns a blank string if there are no instructions' do
      instructions = ''
      result = text_editor(instructions)
      expect(result).to eq('')
    end

    it 'interprets "1" as append and returns that string' do
      instructions = '1 test'
      result = text_editor(instructions)
      expect(result).to eq('test')
    end
  end
end
