def main_menu
  puts 'Выберите нужный пункт меню:'
  puts 'ЖД меню:'
  puts '1. Создать станцию'
  puts '2. Создать поезд'
  puts '3. Создать маршрут'
  puts '4. Добавить/Удалить/Посмотреть станции в маршруте'
  puts '5. Назначить маршрут поезду'
  puts '6. Добавить вагоны поезду'
  puts '7. Отцепить вагоны от поезда'
  puts '8. Занять места или пространство в вагоне'
  puts '9. Перемещать поезд по маршруту'
  puts '10. Просматривать список станций'
  puts '11. Список поездов на станции'
  puts '12. Cписок вагонов поезда'
  puts '13. Завести тестовые данные (станции, маршруты, поезда)'
  puts '14. Выход'
end

def stations_list(stations)
  stations.each.with_index(1) do |station, index|
    puts "#{index}. Станция \"#{station.name}\""
  end
end

def trains_list(trains)
  trains.each.with_index(1) do |train, index|
    puts "#{index}. Поезд №#{train.number}, #{train.type}"
  end
end

def trains_station_list(station)
  if station.trains.any?
    puts "Поезда на станции #{station.name}:"
    station.each_train { |train| puts train }
  else
    puts 'Поездов нет.'
  end
end

def wagons_list(train)
  puts train
  train.each_wagon do |wagon|
    if wagon.instance_of?(CargoWagon)
      unless wagon.full?
        puts "Груз. вагон #{train.wagons.index(wagon) + 1}. Свободно: #{wagon.free_space}т. " \
        "Занято: #{wagon.occupied_volume}т."
      end
    else
      unless wagon.full?
        puts "Пассажирский вагон №#{train.wagons.index(wagon) + 1}. Свободно: " \
        "#{wagon.free_seats}мест. Занято: #{wagon.occupied_seats}мест."
      end
    end
  end
end

def routes_list(routes)
  routes.each.with_index(1) do |route, index|
    puts "#{index}. #{route.route_name}"
  end
end

def route_update_message(route)
  puts "Маршрут обновлен: #{route.route_stations_list}"
end

def wagon_quantity_input
  puts 'Укажите количество вагонов:'
end

def wagon_seats_input
  puts 'Укажите количество мест в вагоне:'
end

def wagon_volume_input
  puts 'Укажите доступный объем для груза в ваге:'
end

def train_with_wagons_message(train)
  type = train.instance_of?(CargoTrain) ? 'тонн каждый' : 'мест каждый'
  puts "В поезде #{train.number}:#{train.type} - #{train.wagons.size} вагонов," \
  " #{train.wagons.first.space_total} #{type}"
end

def train_status_message(train)
  puts "Поезд #{train.number} едет по маршруту #{train.route.route_stations_list}" \
  " и прибыл на станцию #{train.current_station.name}"
end

def no_space_message
  puts 'Не хватает места.'
end

def seed_message
  puts 'Тестовые данный созданы.'
end

def edit_route_message
  puts 'Редактировать маршрут:'
  puts '1. Добавить промежуточную станцию 2. Удалить промежуточную станцию 3. Показать маршрут'
end

def route_error_message
  puts 'Сначала создайте маршрут и промежуточные станции для добавления'
end
