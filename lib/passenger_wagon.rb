class PassengerWagon < Wagon
  attr_reader :occupied_seats

  def initialize(seats_total = 35)
    @occupied_seats = 0
    super
  end

  def take_seat
    @occupied_seats += 1 unless full?
  end

  def free_seats
    space_total - @occupied_seats
  end

  def full?
    @occupied_seats == space_total
  end
end

