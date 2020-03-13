class Wagon
  include Manufacturer

  attr_reader :space_total

  def initialize(space_total)
    @space_total = space_total
  end
end
