class Train
  attr_accessor :wagon_count, :current_stop, :speed

  attr_reader :type

  def initialize(number, type, wagon_count)
    @number = number
    @type = type
    @wagon_count = wagon_count
    @speed = 0
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

  def add_wagon
    self.wagon_count += 1 unless in_motion?
  end

  def remove_wagon
    @wagon_count -= 1 unless in_motion?
  end

  def set_route(route)
    @route = route
    @current_stop = @route.first_station
    set_train_to_station
    @current_route_index = 0
  end

  def set_train_to_station
    current_stop.add_train(self)
  end

  def train_first_station?
    @current_stop == @route.first_station
  end

  def train_last_station?
    @current_stop == @route.last_station
  end

  def move_train(direction)
    if direction == 'next' && !self.train_last_station?
      current_stop.send_train(self)
      self.current_stop = @route.route_list[@current_route_index += 1]
    elsif direction == 'back' && !self.train_first_station?
      current_stop.send_train(self)
      self.current_stop =@route.route_list[@current_route_index -= 1]
    end
    set_train_to_station
  end

  def previous_stop
    @route.route_list[@current_route_index - 1] unless train_first_station?
  end

  def next_stop
    @route.route_list[@current_route_index + 1] unless train_last_station?
  end
end
