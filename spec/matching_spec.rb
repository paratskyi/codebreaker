require 'spec_helper'

RSpec.describe Matching do
  let(:game) { Game.new('String', 'hell') }
  let(:values) { DbUtils.get('spec/test.yml') }

  context '#matching' do
    it 'it should return correct result with different values' do
      values.each do |value|
        game.instance_variable_set(:@secret_code, value[:secret_code].each_char.map(&:to_i))
        game.instance_variable_set(:@user_code, value[:input].each_char.map(&:to_i))
        expect(Matching.new(game).create_response).to eq(value[:result])
      end
    end
  end
end
