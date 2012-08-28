#RubyWarrior - beginner - Level 07
class Player
  
  def initialize
    @max_health = 20
    @min_health = 10
    @health = @max_health
    @direction = :@backward
  end
  
  def play_turn(warrior)
    @warrior = warrior
    
    if @warrior.feel.empty? then
      if (under_attack? && low_health?) then run_away!
      elsif (!under_attack? && injured?) then @warrior.rest!
      else @warrior.walk! end
    else
      if @warrior.feel.enemy? then @warrior.attack!
      elsif @warrior.feel.captive? then @warrior.rescue!
      elsif @warrior.feel.wall? then
        @warrior.pivot!
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
  
  def run_away!
    if @direction == :backward then
      @warrior.walk! :forward
    else
      @warrior.walk! :backward
    end
  end
end