require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
require 'yang'

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

describe 'the yang bot' do
  before :each do
    @bot = Yang.new
  end

  describe 'when initializing' do
    it 'should not accept arguments' do
      lambda { Yang.new :foo }.should raise_error(ArgumentError)
    end
    
    it 'should succeed' do
      lambda { Yang.new }.should_not raise_error
    end
    
    it 'should return a bot of the correct class' do
      Yang.new.should be_a_kind_of(Yang)
    end
  end

  describe 'once initialized' do
    it 'should have a name' do
      @bot.name.should_not be_nil
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
    
    it 'should return paper' do
      @bot.play.should == 'P'
    end
  end
  
  describe 'when screwing the other players' do
    it 'should not allow any arguments' do
      lambda { @bot.screw_others :foo }.should raise_error(ArgumentError)
    end
    
    it 'should force other classes with #play methods to return a rock-throwing bot instead' do
      @bot.screw_others
      [TestSucker, TestLoser, TestFool].each do |klass|
        klass.new.should be_instance_of(Yang::RockThrower)
      end
    end
    
    it 'should not force its own class to return a rock-throwing bot' do
      @bot.screw_others
      @bot.class.new.should be_instance_of(Yang)
    end
  end
  
  describe 'rock-thrower bot' do
    before :each do
      @bot = Yang::RockThrower.new
    end

    describe 'when initializing' do
      it 'should not accept arguments' do
        lambda { Yang::RockThrower.new :foo }.should raise_error(ArgumentError)
      end

      it 'should succeed' do
        lambda { Yang::RockThrower.new }.should_not raise_error
      end

      it 'should return a bot of the correct class' do
        Yang::RockThrower.new.should be_a_kind_of(Yang::RockThrower)
      end
    end
    
    describe 'once initialized' do
      it 'should have a name' do
        @bot.name.should_not be_nil
      end

      it 'should have a play method' do
        @bot.should respond_to(:play)
      end
    end
    
    describe 'play' do
      it "should accept the prior opponent's play" do
        lambda { @bot.play('S') }.should_not raise_error(ArgumentError)
      end
      it 'should return rock' do
        @bot.play.should == 'R'
      end
    end
  end
end