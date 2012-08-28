#RubyWarrior - beginner -Level 02
class Player
  def play_turn(warrior)
    if warrior.feel.empty? then
      warrior.walk!
    else
      warrior.attack!
    end
  end
end