#RubyWarrior - intermediate - Level 08
class Player
  
  DIRECTIONS = [:forward, :right, :left, :backward]
  
  def initialize
    @max_health = 20
    @min_health = 4
    @health = @max_health
    @direction = :forward
    @next_direction = :forward
  end
  
  def play_turn(warrior)
    choose_player(warrior)
    update_health!
    @direction = read_map
    finish_turn = false
    surroundings = @warrior.listen
    
    if surrounded? then
      if @next_direction == :forward then
        @warrior.bind! :left
        finish_turn = true
        @next_direction = :right
      elsif @next_direction == :right then
        @warrior.bind! :right
        finish_turn = true
        @next_direction = :forward
      end
    end
    
    surroundings.each do |s|
      if s.captive? && s.ticking? then
        @next_direction = @warrior.direction_of s
        if captive_in_direction? @next_direction then
          rescue! @next_direction
          finish_turn = true
          break
        end
      elsif !s.ticking? && !enemy_in_direction?(@next_direction)
        if low_health? && surrounded? then
          run_away!
          finish_turn = true
          break
        elsif low_health? && !surrounded?
          rest!
          finish_turn = true
          break
        end
      end unless finish_turn
    end
            
    #if still in our turn, check if we can attack!
    DIRECTIONS.each do |d|
      if enemies_ahead?(d) && !low_health? then
        @warrior.detonate! d
        finish_turn = true
        break
      elsif enemy_in_direction?(d) && !low_health? then
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
    
    #check if we can continue
    if nothing_in_direction?(@next_direction) then
      walk! @next_direction
      finish_turn = true
    end unless finish_turn
    
    #if still in our turn, decide the next action
    DIRECTIONS.each do |d|
      if injured? && nothing_in_direction?(d) then
        rest!
        finish_turn = true
        break
      elsif nothing_in_direction?(d) then
        @next_direction = d
        walk! @next_direction
        finish_turn = true
        break
      elsif wall_in_direction?(d) then
        @next_direction = @direction
        walk! @next_direction
        finish_turn = true
        break
      elsif stairs_in_direction?(d) then
        walk! d
        finish_turn = true
        break
      end unless finish_turn
    end
  end
  
  def low_health?
    @health <= @min_health
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
  
  def surrounded?
    closed_paths = 0
    DIRECTIONS.each do |d|
      if enemy_in_direction?(d) then
        closed_paths += 1
      end
    end
    (closed_paths >= 2)? true : false
  end
  
  def enemies_ahead?(direction)
     space = @warrior.look(direction)
     units = Array.new
     
     space.each do |s|
       units.push(s.character)
     end
     
     if units[0] == '' then return false
     elsif units[1] == 's' then return true
     end
  end
end