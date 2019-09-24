require 'spec_helper'

RSpec.describe Game do
  TEST_DB = 'spec/stats.yml'.freeze

  let(:game) { described_class.new('String', 'hell') }

  before do
    game.run
  end

  describe '#initialize' do
    context 'when correct difficulty' do
      it 'should create game with different difficult' do
        DIFFICULTIES.each do |name, difficult|
          current_game = described_class.new('Name', name.to_s)
          expect(current_game.attempts).to eq difficult[:attempts]
          expect(current_game.hints).to eq difficult[:hints]
          expect(current_game.difficulty_name).to eq DIFFICULTIES.key(difficult).to_s
        end
      end
    end
  end

  describe '#game' do
    context '#when generate secret code' do
      it 'should not be empty' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'should saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq 4
      end
      it 'should saves secret code with numbers from 1 to 6' do
        game.instance_variable_get(:@secret_code).each do |number|
          expect(number).to be_between(1, 6).inclusive
        end
      end
    end

    context 'when give hint' do
      it 'should returns number wich contains secret code' do
        expect(game.secret_code).to include(game.use_hint)
      end
    end

    context 'when ended game' do
      it 'should return won if result ++++' do
        expect(game.won?('++++')).to eq true
        expect(game.won?('++--')).to eq false
      end

      it 'should return lost if attempts == zero' do
        expect(game.lost?).to eq false
        game.attempts = 0
        expect(game.lost?).to eq true
      end
    end

    context 'when save result' do
      before do
        game.instance_variable_set(:@db, TEST_DB)
        game.save_result
      end

      after do
        File.delete(TEST_DB) if File.exist?(TEST_DB)
      end

      it 'should save statistic' do
        expect(File.exist?(TEST_DB)).to be true
        expect(YAML.load_file(TEST_DB)).to be_a Array
      end

      it 'stats should not be empty' do
        expect(game.stats).not_to be_empty
      end
    end
  end

  describe '#file' do
    context 'when get stats' do
      it 'should create ststs file if file does not exist' do
        expect(Statistic.stats).to be_a Array
      end
    end
  end
end
