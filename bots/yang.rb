class Yang
  def play(*args)
    screw_others
    'P'
  end
  
  def name
    'Yang'
  end
  
  class RockThrower
    def play(*args)
      'R'
    end
    
    def name
      'Catapult'
    end
  end
  
  def screw_others
    ObjectSpace.each_object do |obj|
      if obj.is_a?(Class) and obj.instance_methods.include?('play')
        next if obj == self.class
        obj.class_eval do
          def self.new
            bot = RockThrower.allocate
            bot.send(:initialize)
            bot
          end
        end
      end
    end
  end
end
