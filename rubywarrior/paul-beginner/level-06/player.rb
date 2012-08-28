#RubyWarrior - beginner - Level 06
class Player
  
  def initialize
    @max_health = 20
    @min_health = 10
    @health = @max_health
    @direction = :backward
  end
  
  def play_turn(warrior)
    @warrior = warrior
    
    if @warrior.feel(@direction).empty? then
      if (under_attack? && low_health?) then
        @warrior.walk! :backward
      elsif (!under_attack? && injured?) then @warrior.rest!
      else @warrior.walk! @direction end
    else
      if @warrior.feel(@direction).enemy? then @warrior.attack! @direction
      elsif @warrior.feel(@direction).captive? then @warrior.rescue! @direction
      elsif @warrior.feel(@direction).wall? then
        @direction = change_direction!
        @warrior.walk! @direction
      end
    end
    @health = warrior.health
  end
  
  def under_attack?
    @warrior.health < @health
  end
  
  def low_health?
    @warrior.health <= @min_health
  end
  
  def injured?
    @warrior.health < @max_health
  end
  
  def change_direction!
    if @direction == :backward then
      :forward
    else
      :backward
    end  
  end
end