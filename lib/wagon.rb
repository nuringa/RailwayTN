class Wagon
  include Manufacturer

  attr_reader :space_total

  def initialize(space_total = 100)
    @space_total = space_total.to_i
  end
end
