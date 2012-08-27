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
    choose_player(warrior)
    
    if nothing_in_front? then
      if injured? then decide_next_move!
      else walk!
      end
    else
      if enemy_in_front? then attack!
      elsif captive_in_front? then rescue!
      elsif wall_in_front? then turn_around!
      end
    end
    update_health!
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
    if between_enemies? then walk!
    elsif incoming_enemy? then shoot!
    elsif path_is_clear? then rest!
    elsif wall_in_front? then turn_around!
    elsif low_health? then run_away!
    else walk! end
  end
  
  def between_enemies?
    enemy_ahead? && enemy_ahead?(:backward)
  end
  
  def incoming_enemy?
    enemy_ahead? && !enemy_ahead?(:backward)
  end
  
  def path_is_clear?
    !enemy_ahead? && !enemy_ahead?(:backward)
  end
  
  def choose_player(warrior)
    @warrior = warrior
  end
  
  def walk!
    @warrior.walk!
  end
  
  def nothing_in_front?
    @warrior.feel.empty?
  end
  
  def enemy_in_front?
    @warrior.feel.enemy?
  end
  
  def attack!
    @warrior.attack!
  end
  
  def captive_in_front?
    @warrior.feel.captive?
  end
  
  def rescue!
    @warrior.rescue!
  end
  
  def wall_in_front?
    @warrior.feel.wall?
  end
  
  def turn_around!
    @warrior.pivot!
  end
  
  def shoot!
    @warrior.shoot!
  end
  
  def update_health!
    @health = @warrior.health
  end
  
  def rest!
    @warrior.rest!
  end
end