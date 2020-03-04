class Route
  attr_reader :first_station, :last_station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @midway_stations = []
  end

  def add_midway_station(station)
    @midway_stations.push(station)
  end

  def delete_midway_station(station)
    @midway_stations.delete(station)
  end

  def route_list
    [@first_station] + @midway_stations + [@last_station]
  end
end
