# There are Y mechanical horses and a single racetrack
# Each horse completes the track in a pre-programmed time
# and the horses all have different finishing times, unknown to you
# You can race X horses at a time
# After a race is over, you get a printout with the order the horses finished, but not the finishing times of the horses
# Determine the fastest horse

# methods below could be put a class
def generate_random_string(length)
  (0...length).map { ('a'..'z').to_a[rand(26)] }.join
end

def generate_random_float(lower, upper)
  rand(Float(lower)..Float(upper))
end

class Horse
  attr_accessor :name, :speed

  def initialize(name, speed)
    @name = name
    @speed = speed
  end

  def to_s
    "#{@name}: speed: #{@speed}"
  end

  protected

  def <=>(other)
    @speed <=> other.speed
  end

end

class Course
  attr_accessor :name, :capacity

  def initialize(name, capacity)
    @name = name
    @capacity = capacity
  end

  def race(horses)
    if horses.length > @capacity
      raise ArgumentError, "There can not be more horses in a race than there is capacity for: horses > capacity / #{horses.length} > #{@capacity} !"
    else
      horses.sort.reverse
    end
  end

end

# not ideal that we mutate the horses list here!
def get_fastest_horse!(horses, course)
  capacity = course.capacity
  puts "Need #{horses.size / (capacity-1)} races to determine the fastest horse!"
  while horses.size > 1
    race_horses = horses[0..capacity - 1]
    race_order = course.race(race_horses)
    losers = race_order[1..-1]
    losers.each { |horse| horses.delete(horse) }
  end
  horses[0]
end

course = Course.new('Hippodroom', 5)
horse_names = (0...25).map{generate_random_string(10) }
#horse_names = ['schimmel', 'Bucephalus', 'paard1', 'paard2', 'paard3', 'paard4', 'paard5']
horses = horse_names.map { |name| Horse.new(name, generate_random_float(1, 10).round(2)) }
puts "fastest horse is: #{get_fastest_horse!(horses, course)}"

# Oneliner version
# formula for amount of races for a given amount of horses X and a course with capacity Y
# X/Y-1
capacity = 5
horses = (1...53).to_a
amount_of_horses = horses.size
amount_of_races = horses.size / (capacity-1)
p "horses: #{horses}"
p "amount of horses: #{amount_of_horses}"
p "amount of races: #{amount_of_races}"
fastest_horse = (0...amount_of_races).inject {|fastest_horse, race_iteration| horses[(race_iteration * capacity) - (race_iteration-1)..(race_iteration * capacity) + (capacity - race_iteration -1)].push(fastest_horse).sort.reverse[0]}
puts "fastest horse is #{fastest_horse}"
