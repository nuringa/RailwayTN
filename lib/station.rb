class Station
  include InstanceCounter

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
  end

  def add_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def cargo_trains
    trains.select { |train| train.type == 'cargo'}
  end

  def passanger_trains
    trains.select { |train| train.type == 'passenger'}
  end
end
