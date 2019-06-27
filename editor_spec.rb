require_relative 'editor'

describe 'text editor' do
  describe 'single instructions' do
    it 'returns a blank string if there are no instructions' do
      instructions = ''
      result = text_editor(instructions)
      expect(result).to eq('')
    end

    it 'interprets "1" as append and returns "test-1"' do
      instructions = '1 test-1'
      result = text_editor(instructions)
      expect(result).to eq('test-1')
    end

    it 'interprets "1" as append and returns "test-2"' do
      instructions = '1 test-2'
      result = text_editor(instructions)
      expect(result).to eq('test-2')
    end
  end
end
