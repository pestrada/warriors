#RubyWarrior Level 09
class Player
  
  def initialize
    @max_health = 20
    @min_health = 6
    @health = @max_health
    @direction = :forward
  end
  
  def play_turn(warrior)
    @warrior = warrior
    
    if @warrior.feel.empty? then
      if under_attack? then decide_next_move
      elsif (!under_attack? && injured?) then @warrior.rest!
      elsif (!under_attack? && !low_health?) then set_direction!
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
    @warrior.walk! :backward
  end
  
  def enemy_ahead?(direction)
     space = @warrior.look(direction)
     units = Array.new
     
     space.each do |s|
       units.push(s.character)
     end
     
     if units.include?('a') then return true
     elsif units.include?('w') then return true
     else return false
     end
  end
  
  def decide_next_move
    if enemy_ahead?(@direction) then @warrior.shoot!
    elsif low_health? then run_away!
    else @warrior.walk! end
  end
  
  def set_direction!
    if (enemy_ahead? :backward) then
      @warrior.pivot!
    elsif (enemy_ahead? :forward) then
      @warrior.pivot!
    else @warrior.walk!
    end
  end
end