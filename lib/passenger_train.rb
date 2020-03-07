class PassengerTrain < Train
  private

  def type?(wagon)
    wagon.instance_of?(PassengerWagon)
  end
end
