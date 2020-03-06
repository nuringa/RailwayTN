class Route
  attr_reader :first_station, :last_station, :route_name, :midway_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @midway_stations = []
    @route_name = "#{first_station.name}->#{last_station.name}"
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
    "#{first_station.name}->" + midway_stations.map { |station| "#{station.name}" }.join('->') + "->#{last_station.name}"
  end

  def route_empty?
    midway_stations.empty?
  end
end
