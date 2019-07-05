require 'spec_helper'

module CodebreakerParatskiy
  RSpec.describe Game do
    describe '#run' do
      it 'generates secret code' do
        game = Game.new
        game.run
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do 
        game = Game.new
        game.run
        expect(game.instance_variable_get(:@secret_code).length).to eq 4
      end
      it 'saves secret code with numbers from 1 to 6' do
        game = Game.new
        game.run
        expect(game.generate_number).to be_between(1, 6).inclusive
      end
      # it 'saves matches from secret code and user code' do
      #   game = Game.new
      #   expect()
      # end
      it 'return result from check secret code and user code' do
        game = Game.new
        game.run
        game.secret_code = [1, 2, 3, 4]
        expect(game.result([3, 1, 2, 4])).to eq '+---'
      end
    end
  end
end

RSpec.describe Console do

end