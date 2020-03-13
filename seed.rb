class Seed
  attr_reader :stations, :trains, :routes
  def initialize
    @stations = []
    @trains = []
    @routes = []

    6.times do
      @stations << Station.new(%w(a b c d).sample + %w(l m n o p).sample + %w(1 2 3 4 5).sample)
    end

    @trains << CargoTrain.new('Car-go', :cargo) << PassengerTrain.new('Pas-er', :passenger)
    @routes << Route.new(stations.first, stations.last)

    6.times do
      @trains[0].wagons << CargoWagon.new
    end
    @trains[0].wagons[0].add_cargo(50)
    @trains[0].wagons[1].add_cargo(10)
    @trains[0].wagons[2].add_cargo(60)

    @routes.first.add_midway_station(stations[1])
    @routes.first.add_midway_station(stations[2])
  end
end
