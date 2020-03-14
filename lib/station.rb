class Station
  include InstanceCounter
  include Validator

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
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

  def each_train(&block)
    trains.each { |train| yield train }
  end

  def cargo_trains
    trains.select { |train| train.type == 'cargo'}
  end

  def passenger_trains
    trains.select { |train| train.type == 'passenger'}
  end

  private

  def validate!
    raise 'Название слишком короткое или длинное' unless (3..40).include?(name.length)
  end
end
