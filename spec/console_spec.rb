require 'spec_helper'

RSpec.describe Console do
  let(:console) { described_class.new }
  let(:game) { Game.new('test', DIFFICULTIES[:easy]) }

  describe '#run' do
    context 'when run console' do
      it 'should show welcome message' do
      end
    end
  end

  describe '#main_menu' do
    context 'when correct method calling' do
      it 'should call method start' do
        allow(console).to receive(:_get_name).and_return('test')
        allow(console).to receive(:_get_difficulty_level) { DIFFICULTIES[:easy] }
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
    let(:incorrect_names) { %w[qwe qwertyuiopasdfghjklz] }
    context 'when correct user enter' do
      it 'should return name' do
        allow(console).to receive(:user_enter).and_return('test')
        expect(console).to receive(:show_msg).with(:EnterName)
        expect { console.send(:_get_name) }.to_not raise_error
      end

      it 'should return difficult hash' do
        allow(console).to receive(:user_enter).and_return('easy')
        expect(console).to receive(:show_msg).with(:EnterDifficulty)
        expect(console.send(:_get_difficulty_level)).to eq(DIFFICULTIES[:easy])
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

  # describe '#won' do
  #   context 'when save result' do
  #     it 'should save result if user_enter = yes' do
  #       allow(console).to receive(:user_enter).and_return('yes', 'no')
  #       expect(console).to receive(:show_msg).with(:SaveResult).twice

  #     end
  #   end
  # end
end
