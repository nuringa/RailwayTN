def main_menu
  puts 'ЖД меню:'
  puts '1. Создать станцию'
  puts '2. Создать поезд'
  puts '3. Создать маршрут'
  puts '4. Добавить/Удалить/Посмотреть станции в маршруте'
  puts '5. Назначить маршрут поезду'
  puts '6. Добавить вагоны поезду'
  puts '7. Отцепить вагоны от поезда'
  puts '8. Перемещать поезд по маршруту'
  puts '9. Просматривать список станций и поездов на станциях'
  puts '10. Завести тестовые данные (станции, маршруты, поезда)'
  puts '11. Выход'
end

def stations_list(stations)
  stations.each.with_index(1) do |station, index|
    puts "#{index}. Станция \"#{station.name}\""
    if station.trains.any?
      puts "Поезда: #{trains_on_station(station)}"
    end
  end
end

def trains_on_station(station)
  station.trains.map { |train| "#{train.number}:#{train.type}" }.join', '
end

def routes_list(routes)
  routes.each.with_index(1) do |route, index|
    puts "#{index}. #{route.route_name}"
  end
end

def trains_list(trains)
  trains.each.with_index(1) do |train, index|
    puts "#{index}. Поезд №#{train.number}, #{train.type}"
  end
end

def route_update_message(route)
  puts "Маршрут обновлен: #{route.route_stations_list}"
end

def wagon_quantity_input
  puts 'Укажите количество вагонов:'
end

def train_with_wagons_message(train)
  puts "В поезде #{train.number}:#{train.type} - #{train.wagons.size} вагонов"
end

def train_status_message(train)
  puts "Поезд #{train.number} едет по маршруту #{train.route.route_stations_list} и прибыл на станцию #{train.current_station.name}"
end