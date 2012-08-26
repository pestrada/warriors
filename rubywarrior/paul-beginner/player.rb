#RubyWarrior Level 09
#first score: 538 - epic score: 526
class Player
  
  def initialize
    @max_health = 20
    @min_health = 5
    @health = @max_health
    @direction = :forward
  end
  
  def play_turn(warrior)
    @warrior = warrior
    
    if @warrior.feel.empty? then
      if injured? then decide_next_move!
      else @warrior.walk!
      end
    else
      if @warrior.feel.enemy? then @warrior.attack!
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
     elsif units.include?('S') then return true
     else return false
     end
  end
  
  def decide_next_move!
    if between_enemies? then @warrior.walk!
    elsif incoming_enemy? then @warrior.shoot!
    elsif path_is_clear? then @warrior.rest!
    elsif @warrior.feel.wall? then @warrior.pivot!
    elsif low_health? then run_away!
    else @warrior.walk! end
  end
  
  def between_enemies?
    enemy_ahead?(@direction) && enemy_ahead?(:backward)
  end
  
  def incoming_enemy?
    enemy_ahead?(@direction) && !enemy_ahead?(:backward)
  end
  
  def path_is_clear?
    !enemy_ahead?(@direction) && !enemy_ahead?(:backward)
  end
  
end