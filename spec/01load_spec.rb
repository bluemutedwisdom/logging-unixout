require 'logger/unixout'

describe Logger::Unixout do

    it "creates a new object" do
        expect(Logger::Unixout.new).to be_a Logger::Unixout
    end

end
