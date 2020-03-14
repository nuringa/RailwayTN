class Train
  include Manufacturer
  include InstanceCounter
  include Validator

  attr_accessor :speed
  attr_reader :number, :wagons, :route, :type

  NUMBER_FORMAT = /^[a-z0-9а-я]{3}-?[a-z0-9а-я]{2}$/i.freeze

  @@trains = {}

  def self.find(train_number)
    @@trains[train_number]
  end

  def initialize(number, type)
    @type = type == :cargo ? 'Грузовой' : 'Пассажирский'
    @number = number
    validate!
    @speed = 0
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def speed_up(speed)
    self.speed += speed
  end

  def speed_down
    self.speed = 0
  end

  def each_wagon(&block)
    wagons.each { |wagon| yield wagon }
  end

  def add_wagon(wagon)
    @wagons << wagon if not_moving?
  end

  def remove_wagon
    @wagons.pop if not_moving?
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
    @route.route_stations_list[@current_route_index - 1] unless train_first_station?
  end

  def next_stop
    @route.route_stations_list[@current_route_index + 1] unless train_last_station?
  end

  def to_s
    "Поезд№#{number}, #{type}, #{wagons.count} вагонов"
  end

  private
  def validate!
    raise 'Номер поезда не соответствует формату' unless number =~ NUMBER_FORMAT
    raise "Поезд с номером #{number} уже существует." if @@trains.has_key?(number)
    raise 'Указан не верный тип поезда' unless type == 'Грузовой' || type == 'Пассажирский'
  end

  def not_moving?
    speed.zero?
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
end
