class CargoTrain < Train
  private

  def type?(wagon)
    wagon.instance_of?(CargoWagon)
  end
end
