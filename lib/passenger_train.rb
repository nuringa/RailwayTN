class PassengerTrain < Train
  private

  def type?(wagon)
    wagon.is_a?(PassengerWagon)
  end
end
