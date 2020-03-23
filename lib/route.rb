class Route
  include InstanceCounter
  include Validation

  attr_reader :first_station, :last_station, :route_name, :midway_stations

  validate :first_station, :uniqness, :last_station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    validate!
    @midway_stations = []
    @route_name = "#{first_station.name}->#{last_station.name}"
    register_instance
  end

  def add_midway_station(station)
    midway_stations.push(station)
  end

  def delete_midway_station(station)
    midway_stations.delete(station)
  end

  def route_stations
    [first_station] + midway_stations + [last_station]
  end

  def route_stations_list
    "#{first_station.name}->" + midway_stations.map { |station| station.name.to_s }
                                               .join('->') + "->#{last_station.name}"
  end
end
