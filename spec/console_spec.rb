require 'spec_helper'

RSpec.describe Console do
  let(:console) { described_class.new }

  describe '#run' do
    context 'when correct method calling' do
      after do
        console.run
      end

      it 'start' do
        allow(console).to receive(:user_enter).and_return('start')
        expect(console).to receive(:start)
      end

      it 'rules' do
        allow(console).to receive(:user_enter).and_return('rules')
        expect(console).to receive(:rules)
      end

      it 'stats' do
        allow(console).to receive(:user_enter).and_return('stats')
        expect(console).to receive(:stats)
      end

      it 'exit' do
        allow(console).to receive(:user_enter).and_return('exit')
        expect(console).to receive(:exit)
        exit
      end
    end
  end
end
