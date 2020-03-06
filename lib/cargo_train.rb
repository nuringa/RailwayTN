class CargoTrain < Train

  def type
    'Грузовой'
  end

  private

  def check_class(wagon)
    wagon.is_a?(CargoWagon)
  end
end
