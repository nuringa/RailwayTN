class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
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
