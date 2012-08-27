#RubyWarrior - intermediate - Level 01
class Player
  
  def initialize
    @max_health = 20
    @min_health = 5
    @health = @max_health
    @direction = :forward
  end
  
  def play_turn(warrior)
    choose_player(warrior)
    @direction = read_map
    
    if nothing_in_direction?(@direction) then
      walk! @direction
    else
      if enemy_in_front? then attack!
      elsif captive_in_front? then rescue!
      elsif wall_in_front? then turn_around!
      end
    end
  end
  
  def under_attack?
    @warrior.health < @health
  end
  
  def low_health?
    @warrior.health <= @min_health
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
    else walk! @direction end
  end
  
  def between_enemies?
    enemy_ahead?(:forward) && enemy_ahead?(:backward)
  end
  
  def incoming_enemy?
    enemy_ahead?(:forward) && !enemy_ahead?(:backward)
  end
  
  def path_is_clear?
    !enemy_ahead?(:forward) && !enemy_ahead?(:backward)
  end
  
  def choose_player(warrior)
    @warrior = warrior
  end
  
  def walk!(direction)
    @warrior.walk! direction
  end
  
  def nothing_in_direction?(direction)
    @warrior.feel(direction).empty?
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

  def rest!
    @warrior.rest!
  end
  
  def read_map
    @warrior.direction_of_stairs
  end
end