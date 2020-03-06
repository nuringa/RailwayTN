class Train
  attr_accessor :speed

  attr_reader :number, :wagons, :route

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
  end

  def speed_up(speed)
    self.speed += speed
  end

  def speed_down
    self.speed = 0
  end

  def in_motion?
    speed > 0
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagon
    @wagons.pop unless in_motion?
  end

  def set_route(route)
    @route = route
    @route.first_station.add_train(self)
    @current_route_index = 0
  end

  def current_station
    @route.route_stations.detect do |station|
      station.trains.include?(self)
    end
  end

  def train_first_station?
    current_station == @route.first_station
  end

  def train_last_station?
    current_station == @route.last_station
  end

  def leave_station
    current_station.send_train(self)
  end

  def move_next_station
    return if train_last_station?

    leave_station
    @route.route_stations[@current_route_index += 1].add_train(self)
  end

  def move_previous_station
    return if train_first_station?

    leave_station
    @route.route_stations[@current_route_index -= 1].add_train(self)
  end

  def previous_stop
    @route.route_list[@current_route_index - 1] unless train_first_station?
  end

  def next_stop
    @route.route_list[@current_route_index + 1] unless train_last_station?
  end
end
