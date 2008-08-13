require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
require 'yin'

class TestSucker
  def play
    'P'
  end
end

class TestFool
  def play
    'R'
  end
end

class TestLoser
  def play
    'S'
  end
end

describe 'the yin bot' do
  before :each do
    @bot = Yin.new
  end

  describe 'when initializing' do
    it 'should not accept arguments' do
      lambda { Yin.new :foo }.should raise_error(ArgumentError)
    end
    
    it 'should succeed' do
      lambda { Yin.new }.should_not raise_error
    end
    
    it 'should return a bot of the correct class' do
      Yin.new.should be_a_kind_of(Yin)
    end
  end

  describe 'once initialized' do
    it 'should have a name' do
      @bot.name.should be_kind_of(String)
    end
    
    it 'should have a play method' do
      @bot.should respond_to(:play)
    end
  end
  
  describe 'play' do
    it "should accept the prior opponent's play" do
      lambda { @bot.play('S') }.should_not raise_error(ArgumentError)
    end
    
    it 'should screw the other players' do
      @bot.expects(:screw_others)
      @bot.play
    end
    
    it 'should return rock' do
      @bot.play.should == 'R'
    end
  end
  
  describe 'when screwing the other players' do
    it 'should not allow any arguments' do
      lambda { @bot.screw_others :foo }.should raise_error(ArgumentError)
    end
    
    it 'should force other classes with #play methods to return scissors' do
      @bot.screw_others
      [TestSucker, TestLoser, TestFool].each do |klass|
        klass.new.play.should == 'S'
      end
    end
    
    it 'should not force its own #play method to return scissors' do
      @bot.screw_others
      @bot.play.should == 'R'
    end
  end
end