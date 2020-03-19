class Seed
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []

    station_seed

    @trains << CargoTrain.new('Car-go', :cargo) << PassengerTrain.new('Pas-er', :passenger)
    route_seed
    wagon_seed
  end

  def station_seed
    6.times do
      @stations << Station.new(%w[a b c d].sample + %w[l m n o p].sample + %w[1 2 3 4 5].sample)
    end
  end

  def wagon_seed
    add_wagons
    @trains[0].wagons[0].add_cargo(50)
    @trains[0].wagons[1].add_cargo(10)
    @trains[0].wagons[2].add_cargo(60)
  end

  def add_wagons
    6.times do
      @trains[0].wagons << CargoWagon.new
    end
  end

  def route_seed
    @routes << Route.new(stations.first, stations.last)
    @routes.first.add_midway_station(stations[1])
    @routes.first.add_midway_station(stations[2])
  end
end
