#RubyWarrior - beginner - Level 08
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
      if under_attack? then decide_next_move!
      elsif (!under_attack? && injured?) then @warrior.rest!
      elsif (!under_attack? && !low_health?) then decide_next_move!
      end
    else
      if (@warrior.feel.enemy? && low_health?) then run_away!
      elsif (@warrior.feel.enemy? && !low_health?) then @warrior.attack!
      elsif @warrior.feel.captive? then @warrior.rescue!
      elsif @warrior.feel.wall? then @warrior.pivot!
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
  
  def wizard_ahead?
     @warrior.look[1].character == 'w'
  end
  
  def decide_next_move!
    if wizard_ahead? then @warrior.shoot!
    elsif low_health? then run_away!
    else @warrior.walk! end
  end
end