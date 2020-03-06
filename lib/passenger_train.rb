class PassengerTrain < Train

  def type
    'Пассажирский'
  end

  private

  def check_class(wagon)
    wagon.is_a?(PassengerWagon)
  end
end
