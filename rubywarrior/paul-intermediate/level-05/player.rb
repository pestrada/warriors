#RubyWarrior - intermediate - Level 05
class Player
  
  DIRECTIONS = [:forward, :backward, :right, :left]
  
  def initialize
    @max_health = 20
    @min_health = 6
    @health = @max_health
    @direction = :forward
    @next_direction = :forward
  end
  
  def play_turn(warrior)
    choose_player(warrior)
    @direction = read_map
    finish_turn = false
    surroundings = @warrior.listen
    
    surroundings.each do |s|
      if s.captive? then
        @next_direction = @warrior.direction_of s
        if captive_in_direction? @next_direction then
          rescue! @next_direction
          finish_turn = true
          break
        end
      end
    end
            
    #if still in our turn, check if we can attack!
    DIRECTIONS.each do |d|
      if enemy_in_direction?(d) && !low_health? then
        @next_direction = d
        attack! @next_direction
        finish_turn = true
        break
      elsif enemy_in_direction?(d) && low_health? then
        run_away!
        finish_turn = true
        break
      end unless finish_turn
    end
    
    #check if all directions are empty
    empty_directions = 0
    DIRECTIONS.each do |d|
      if nothing_in_direction?(d) then
        empty_directions += 1
      end
    end
    
    #check if we need health
    if injured? && empty_directions == 4 then
      rest!
      finish_turn = true
    end
    
    #check if we can continue
    if nothing_in_direction?(@next_direction) then
      walk! @next_direction
      finish_turn = true
    end unless finish_turn
    
    #if still in our turn, decide the next action
    DIRECTIONS.each do |d|
      if injured? then
        rest!
        finish_turn = true
      elsif nothing_in_direction?(d) then
        @next_direction = d
        walk! @next_direction
        finish_turn = true
      elsif wall_in_direction?(d) then
        @next_direction = @direction
        walk! @next_direction
        finish_turn = true
      elsif stairs_in_direction?(d) then
        walk! d
        finish_turn = true
        break
      end unless finish_turn
    end
    update_health!
  end
  
  def low_health?
    @health < @min_health
  end
   
  def injured?
    @warrior.health < @max_health
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
  
  def enemy_in_direction?(direction)
    @warrior.feel(direction).enemy?
  end
  
  def attack!(direction)
    @warrior.attack! direction
  end
  
  def captive_in_direction?(direction)
    @warrior.feel(direction).captive?
  end
  
  def rescue!(direction)
    @warrior.rescue! direction
  end
  
  def wall_in_direction?(direction)
    @warrior.feel(direction).wall?
  end
  
  def update_health!
    @health = @warrior.health
  end
  
  def rest!
    @warrior.rest!
  end
  
  def read_map
    @warrior.direction_of_stairs
  end
  
  def stairs_in_direction?(direction)
    @warrior.feel(direction).stairs?
  end
  
  def run_away!
    @warrior.walk! :backward
  end
end