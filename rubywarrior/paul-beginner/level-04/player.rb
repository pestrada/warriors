#RubyWarrior - beginner - Level 04
class Player
  
  def initialize
    @max_health = 20
    @health = @max_health
  end
  
  def play_turn(warrior)
    @warrior = warrior
    
    if @warrior.feel.empty? then
      if under_attack? then @warrior.walk!
      elsif low_health? then @warrior.rest!
      else @warrior.walk! end
    else
      if @warrior.feel.enemy? then @warrior.attack! end
    end
    @health = warrior.health
  end
  
  def under_attack?
    @warrior.health < @health
  end
  
  def low_health?
    @warrior.health < @max_health
  end
end