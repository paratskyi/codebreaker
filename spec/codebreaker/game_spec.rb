require 'spec_helper'

RSpec.describe Game do
  let(:game) { described_class.new('String', 'hell') }

  before do
    game.run
    game.define_difficulty
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
    it 'defines easy difficulty' do
      game.difficulty = 'easy'
      game.define_difficulty
      expect(game.attempts).to eq 15
      expect(game.hints).to eq 2
    end
    it 'defines medium difficulty' do
      game.difficulty = 'medium'
      game.define_difficulty
      expect(game.attempts).to eq 10
      expect(game.hints).to eq 1
    end
    it 'defines hell difficulty' do
      game.difficulty = 'hell'
      game.define_difficulty
      expect(game.attempts).to eq 5
      expect(game.hints).to eq 1
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
  end
end
