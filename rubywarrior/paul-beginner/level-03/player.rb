#RubyWarrior - beginner - Level 03
class Player
  def initialize()
    @min_hp = 13
  end

  def play_turn(warrior)
    @warrior = warrior

    if @warrior.feel.empty? then
      if low_health? then
        warrior.rest!
      else
        @warrior.walk!
      end
    else
      @warrior.attack!
    end
  end

  def low_health?
    @warrior.health < @min_hp
  end
end