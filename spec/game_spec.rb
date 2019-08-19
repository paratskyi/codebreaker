require 'spec_helper'

RSpec.describe Game do
  let(:game) { described_class.new('String', DIFFICULTIES[:hell]) }

  before do
    game.run
  end

  describe '#create' do
    context 'with all of difficulty' do
      it do
        DIFFICULTIES.each_value do |difficult|
          current_game = described_class.new('Name', difficult)
          expect(current_game.attempts).to eq difficult[:attempts]
          expect(current_game.hints).to eq difficult[:hints]
          expect(current_game.difficulty_name).to eq DIFFICULTIES.key(difficult).to_s
        end
      end
    end
  end

  context '#run' do
    it 'generates secret code' do
      expect(game.instance_variable_get(:@secret_code)).not_to be_empty
    end
    it 'saves 4 numbers secret code' do
      expect(game.instance_variable_get(:@secret_code).length).to eq 4
    end
    it 'saves secret code with numbers from 1 to 6' do
      game.instance_variable_get(:@secret_code).each do |number|
        expect(number).to be_between(1, 6).inclusive
      end
    end
  end

  context '#game' do
    it 'returns result from check secret code and user code' do
      game.secret_code = [1, 2, 3, 4]
      expect(game.result('3124')).to eq '+---'
    end

    it 'returns number wich contains secret code' do
      expect(game.secret_code).to include(game.give_hint)
    end

    it 'return won if result ++++' do
      expect(game.won?('++++')).to eq true
      expect(game.won?('++--')).to eq false
    end

    it 'return lost if attempts == zero' do
      expect(game.lost?).to eq false
      game.attempts = 0
      expect(game.lost?).to eq true
    end
  end
end
