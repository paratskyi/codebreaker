require 'spec_helper'

RSpec.describe Console do
  let(:console) { described_class.new }

  before do
    CodebreakerParatskiy.run_game('test', 'easy')
  end

  let(:game) { CurrentGame.game }

  describe '#run' do
    context 'when run console' do
      it 'should show welcome message' do
        expect(console).to receive(:show_welcome)
        expect(console).to receive(:main_menu)
        console.run
      end
    end
  end

  describe '#main_menu' do
    context 'when correct user enter' do
      it 'should call method start' do
        expect(console).to receive(:show_msg).with(:MainMenu)
        allow(console).to receive(:_get_name).and_return('test')
        allow(console).to receive(:_get_difficulty_level) { DIFFICULTIES[:easy] }
        allow(console).to receive(:user_enter).and_return('start')
        allow(console).to receive(:loop).and_yield
        expect(console).to receive(:start)
        console.main_menu
      end
    end
  end

  describe '#main_menu' do
    context 'when correct method calling' do
      it 'should call method start' do
        allow(console).to receive(:_get_name).and_return('test')
        allow(console).to receive(:_get_difficulty_level) { 'easy' }
        allow(console).to receive(:loop).and_yield
        allow(console).to receive(:user_enter).and_return('1234')
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:start).and_call_original
        console.send(:start)
      end

      it 'should call method rules' do
        allow(console).to receive(:user_enter).and_return('rules')
        expect(console).to receive(:show_msg).with(:Rules)
        expect(console).to receive(:show_rules).and_call_original
        console.show_rules
      end

      it 'should call method stats' do
        allow(console).to receive(:user_enter).and_return('stats')
        expect(console).to receive(:show_stats).and_call_original
        console.show_stats
      end

      it 'should call method exit' do
        allow(console).to receive(:gets).and_return('exit')
        expect(console).to receive(:show_msg).with(:Exit)
        expect(console).to receive(:exit)
        console.send(:user_enter)
      end
    end
  end

  describe '#request_of_hints' do
    context 'when call request of hint' do
      before do
        console.instance_variable_set(:@game, game)
        game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        allow(console).to receive(:loop).and_yield
      end

      it 'should give a hint if they are not ended' do
        allow(console).to receive(:user_enter).and_return('hint')
        expect(console).to receive(:request_of_hint).and_call_original
        console.send(:request_of_hint)
      end

      it 'should show ended msg if hint are ended' do
        game.instance_variable_set(:@hints, 0)
        allow(console).to receive(:user_enter).and_return('hint')
        expect(console).to receive(:show_msg).with(:HintsEnded)
        expect(console).to receive(:request_of_hint).and_call_original
        console.send(:request_of_hint)
      end
    end
  end

  describe '#registration' do
    context 'when correct user enter' do
      it 'should return name' do
        allow(console).to receive(:user_enter).and_return('test')
        expect(console).to receive(:show_msg).with(:EnterName)
        expect(console.send(:_get_name)).to eq('test')
      end

      it 'should return difficult hash' do
        allow(console).to receive(:user_enter).and_return('easy')
        expect(console).to receive(:show_msg).with(:EnterDifficulty)
        expect(console.send(:_get_difficulty_level)).to eq('easy')
      end
    end

    context 'when incorrect user enter' do
      it 'should show message Invalid enter when name.length < 4' do
        allow(console).to receive(:user_enter).and_return('asd', 'test')
        expect(console).to receive(:show_msg).with(:EnterName).twice
        expect(console).to receive(:show_msg).with(:InvalidCommand).once
        console.send(:_get_name)
      end

      it 'should show message Invalid enter when name.length > 20' do
        allow(console).to receive(:user_enter).and_return('a' * 21, 'test')
        expect(console).to receive(:show_msg).with(:EnterName).twice
        expect(console).to receive(:show_msg).with(:InvalidCommand).once
        console.send(:_get_name)
      end

      it 'should show message Invalid enter' do
        allow(console).to receive(:user_enter).and_return('asdf', 'easy')
        expect(console).to receive(:show_msg).with(:EnterDifficulty).twice
        expect(console).to receive(:show_msg).with(:InvalidCommand).once
        console.send(:_get_difficulty_level)
      end
    end
  end

  describe '#game_scenario' do
    before do
      allow(console).to receive(:loop).and_yield
      game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      console.instance_variable_set(:@game, game)
      allow(console).to receive(:registration).and_return(game)
      allow(console).to receive(:user_enter).and_return('start')
    end

    after do
      console.send(:start)
    end

    context 'when correct user enter' do
      it 'should won when user_code and secret_code to equal' do
        allow(console).to receive(:user_enter).and_return('1234')
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:show_msg).with(:Won)
        expect(console).to receive(:show_msg).with(:SaveResult)
        expect(console).to receive(:main_menu)
      end

      it 'should give hint when hint not over' do
        allow(console).to receive(:user_enter).and_return('hint')
        allow(game).to receive(:use_hint).and_return(1)
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:puts).with(1)
      end

      it 'should show message "ended og hints" hint when hints is over' do
        game.instance_variable_set(:@hints, 0)
        allow(console).to receive(:user_enter).and_return('hint')
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:show_msg).with(:HintsEnded)
      end

      it 'should lost when attempts ended' do
        game.instance_variable_set(:@attempts, 0)
        expect(console).to receive(:show_msg).with(:Loss)
        expect(console).to receive(:puts).with(game.secret_code.join)
        expect(console).to receive(:main_menu)
      end
    end

    context 'when incorrect user enter' do
      it 'should show message "invalid enter"' do
        game.instance_variable_set(:@hints, 0)
        allow(console).to receive(:user_enter).and_return('test')
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:show_msg).with(:InvalidCommand)
      end
    end
  end
end
