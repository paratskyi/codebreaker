require 'spec_helper'

RSpec.describe Console do
  let(:console) { described_class.new }
  let(:game) { Game.new('test', DIFFICULTIES[:easy]) }

  describe '#main_menu' do
    context 'when correct method calling' do
      before do
        allow(console).to receive(:_get_name).and_return('test')
        allow(console).to receive(:_get_difficulty_level) { DIFFICULTIES[:easy] }
        allow(console).to receive(:user_enter).and_return('1234')
        allow(console).to receive(:loop).and_yield
      end

      it 'start' do
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console).to receive(:start).and_call_original
        console.start
      end

      it 'rules' do
        expect(console).to receive(:show_msg).with(:Rules)
        expect(console).to receive(:show_rules).and_call_original
        console.show_rules
      end

      it 'stats' do
        # expect(console).to receive(:show_msg).with(:Rules)
        # console.show_stats
      end

      it 'exit' do
        expect(console).to receive(:show_msg).with(:Exit)
        exit
      end
    end

    context 'when hint' do
      before do
        allow(console).to receive(:_get_name).and_return('test')
        allow(console).to receive(:_get_difficulty_level) { DIFFICULTIES[:easy] }
        allow(console).to receive(:user_enter).and_return('hint')
        allow(console).to receive(:loop).and_yield
      end

      it 'take hint' do
        # binding.pry
        expect(console).to receive(:show_msg).with(:AccompanyingMsg)
        expect(console.request_of_hint).to receive(:puts).with()
      end
    end
  end
end
