class CargoWagon < Wagon
  attr_reader :occupied_volume

  def initialize(cargo_volume = 60)
    @occupied_volume = 0
    super
  end

  def add_cargo(quantity)
    if (@occupied_volume + quantity) <= space_total
      @occupied_volume += quantity
    else
      no_space_message
    end
  end

  def free_space
    space_total - @occupied_volume
  end

  def full?
    @occupied_volume == space_total
  end

  def to_s(train)
    "Вагон №#{train.wagons.index[self] + 1}, #{train.type}, #{free_space} т. свободно, #{occupied_volume} т. занято"
  end
end
