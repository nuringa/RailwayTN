require_relative 'menu_printer'

class MenuController
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def menu_choice
    puts 'Выберите нужный пункт меню:'
    user_choice = gets.to_i

    case user_choice
    when 1
      station_add_menu
    when 2
      train_add_menu
    when 3
      route_add_menu
    when 4
      route_edit_menu
    when 5
      train_route_menu
    when 6
      wagon_add_menu
    when 7
      wagon_remove_menu
    when 8
      wagon_occupy_space
    when 9
      train_move_menu
    when 10
      stations_list(@stations)
    when 11
      train_list_menu
    when 12
      wagon_list_menu
    when 13
      seed
      seed_message
    when 14
      exit
    else
      puts 'Неправильная команда'
    end
  end

  def seed
    seed = Seed.new
    @stations = seed.stations
    @trains = seed.trains
    @routes = seed.routes
  end

  private

  def station_add_menu
    puts 'Введите название:'
    station_name = gets.chomp
    @stations << Station.new(station_name)
    puts "Добавлена станция #{station_name}"
  end

  def set_station
    puts 'Выберите станцию:'
    stations_list(@stations)
    @stations[gets.to_i - 1]
  end

  def train_add_menu
    puts 'Какой поезд Вы хотите создать? 1. Пассажирский 2. Грузовой'
    user_choice = gets.to_i
    begin
      puts 'Введите номер поезда'
      train_number = gets.chomp
      case user_choice
      when 1
        @trains << Train.new(train_number, :passenger)
      when 2
        @trains << Train.new(train_number, :cargo)
      end
    rescue RuntimeError => e
      puts e.message
      retry
    end
    puts "Добавлен поезд #{train_number}"
  end

  def route_add_menu
    if @stations.size > 1
      stations_list(@stations)
      puts 'Выберите начальную станцию:'
      user_first_station = gets.to_i
      puts 'Выберите конечную станцию:'
      user_last_station = gets.to_i

      route = Route.new(@stations[user_first_station - 1], @stations[user_last_station - 1])
      @routes << route
      puts "Маршрут #{route.route_name} успешно создан."
    else
      puts 'Сначала создайте станции для маршрута (не меньше 2)'
    end
  end

  def set_route
    puts 'Выберите маршрут:'
    routes_list(@routes)
    @routes[gets.to_i - 1]
  end

  def add_midstation_menu(route, possible_mid_stations)
    puts 'Добавить промежуточную станцию:'
    stations_list(possible_mid_stations)
    route.add_midway_station(possible_mid_stations[gets.to_i - 1])
    route_update_message(route)
  end

  def delete_midstation_menu(route)
    puts 'Удалить промежуточную станцию:'
    stations_list(route.midway_stations)
    route.delete_midway_station(route.midway_stations[gets.to_i - 1])
    route_update_message(route)
  end

  def route_edit_menu
    if @routes.any? && @stations.size > 2
      route = set_route
      possible_mid_stations = @stations.select do |station|
        station unless route.route_stations.include?(station)
      end

      puts 'Редактировать маршрут:'
      puts '1. Добавить промежуточную станцию 2. Удалить промежуточную станцию 3. Показать маршрут'
      user_choice = gets.to_i

      case user_choice
      when 1
        add_midstation_menu(route, possible_mid_stations)
      when 2
        delete_midstation_menu(route)
      when 3
        puts "Текущий маршрут: #{route.route_stations_list}"
      end
    else
      puts 'Сначала создайте маршрут и промежуточные станции для добавления'
    end
  end

  def set_train
    puts 'Выберите поезд:'
    trains_list(@trains)
    @trains[gets.to_i - 1]
  end

  def train_list_menu
    station = set_station
    trains_station_list(station)
  end

  def set_wagon(train)
    wagons_count = train.wagons.size
    wagons_list(train)
    puts "Введите номер вагона(1-#{wagons_count})"
    train.wagons.any? ? train.wagons[gets.to_i - 1] : return
  end

  def wagon_list_menu
    train = set_train
    wagons_list(train)
  end

  def train_route_menu
    if @trains.any? && @routes.any?
      route = set_route
      train = set_train
      train.set_route(route)
      train_status_message(train)
    else
      puts 'Создайте сначала поезд и маршрут'
    end
  end

  def wagon_add_menu
    train = set_train
    wagon_quantity_input
    quantity = gets.to_i

    if train.instance_of?(CargoTrain)
      wagon_volume_input
      volume = gets.to_i
      quantity.times do
        train.add_wagon(CargoWagon.new(volume))
      end
    else
      wagon_seats_input
      seats = gets.to_i
      quantity.times { train.add_wagon(PassengerWagon.new(seats)) }

    end
    wagons_list(train)
  end

  def wagon_remove_menu
    train = set_train
    wagon_quantity_input
    quantity = gets.to_i

    if train.wagons.size >= quantity
      quantity.times { train.remove_wagon }
      train_with_wagons_message(train)
    else
      puts 'Недостаточно вагонов'
    end
  end

  def wagon_occupy_space
    train = set_train
    if train.wagons.any?
      wagon = set_wagon(train)

      if train.instance_of?(CargoTrain)
        puts 'Введите объем груза: (тонн)'
        quantity = gets.to_i
        wagon.add_cargo(quantity)
      else
        wagon.take_seat
      end
      wagons_list(train)
    else
      puts 'Не добавлено вагонов'
    end
  end

  def train_move_menu
    train = set_train
    puts 'Поезд движется: 1. Вперед  2. Назад'
    user_choice = gets.to_i
    if user_choice == 1
      train.move_next_station
      train_status_message(train)
    else
      train.move_previous_station
      train_status_message(train)
    end
  end
end
