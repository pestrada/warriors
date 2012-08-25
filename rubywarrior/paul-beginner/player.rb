#RubyWarrior Level 06
class Player
  
  def initialize
    @max_health = 20
    @health = @max_health
    @critical_health = 10
    @direction = :backward
  end
  
  def play_turn(warrior)
    @warrior = warrior
        
    if @warrior.feel(@direction).empty? then
      if (under_attack? && low_health?) then
        change_direction
        @warrior.walk! @direction
      elsif (!under_attack? && low_health?) then @warrior.rest!
      else @warrior.walk! @direction end
    else
      if @warrior.feel(@direction).enemy? then @warrior.attack! @direction
      elsif @warrior.feel(@direction).captive? then @warrior.rescue! @direction
      elsif @warrior.feel(@direction).wall? then
        @direction = change_direction
      end
    end
    @health = warrior.health
  end
  
  def under_attack?
    @warrior.health < @health
  end
  
  def low_health?
    @warrior.health < @critical_health
  end
  
  def change_direction
    if @direction == :backward then
      :forward
    else
      :backward
    end  
  end
end