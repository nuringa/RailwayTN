require_relative 'menu_printer'

class MenuController
  MENU_CHOICE = {
    1 => :station_add_menu,
    2 => :train_add_menu,
    3 => :route_add_menu,
    4 => :route_edit_menu,
    5 => :train_route_menu,
    6 => :wagon_add_menu,
    7 => :wagon_remove_menu,
    8 => :wagon_occupy_space,
    9 => :train_move_menu,
    10 => :stations_list_menu,
    11 => :train_list_menu,
    12 => :wagon_list_menu,
    13 => :seed,
    14 => :test_accessors,
    15 => :exit
  }.freeze

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def menu_choice
    user_choice = 0
    until (1..14).cover?(user_choice)
      main_menu
      user_choice = gets.to_i
    end

    send(MENU_CHOICE[user_choice])
  end

  def seed
    seed = Seed.new
    @stations = seed.stations
    @trains = seed.trains
    @routes = seed.routes
    seed_message
  end

  private

  def station_add_menu
    begin
      puts 'Введите название:'
      station_name = gets.chomp
      @stations << Station.new(station_name)
    rescue RuntimeError => e
      puts e.message
      retry
    end
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
      add_train(train_number, user_choice)
    rescue RuntimeError => e
      puts e.message
      retry
    end
    puts "Добавлен поезд #{train_number}"
  end

  def add_train(train_number, user_choice)
    case user_choice
    when 1
      @trains << Train.new(train_number, :passenger)
    when 2
      @trains << Train.new(train_number, :cargo)
    end
  end

  def route_add_menu
    if @stations.size > 1
      stations_list(@stations)
      begin
        puts 'Выберите начальную станцию:'
        user_first_station = gets.to_i
        puts 'Выберите конечную станцию:'
        user_last_station = gets.to_i

        route = Route.new(@stations[user_first_station - 1], @stations[user_last_station - 1])
        @routes << route
      rescue RuntimeError => e
        puts e.message
        retry
      end
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

  def stations_list_menu
    stations_list(@stations)
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
      edit_route_message
      user_choice = gets.to_i

      case user_choice
      when 1
        add_midstation_menu(route, possible_mid_stations(route))
      when 2
        delete_midstation_menu(route)
      when 3
        puts "Текущий маршрут: #{route.route_stations_list}"
      end
    else
      route_error_message
    end
  end

  def possible_mid_stations(route)
    @stations.select do |station|
      station unless route.route_stations.include?(station)
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

  def choose_wagon(train)
    wagons_count = train.wagons.size
    wagons_list(train)
    puts "Введите номер вагона(1-#{wagons_count})"
    train.wagons.any? ? train.wagons[gets.to_i - 1] : nil
  end

  def wagon_list_menu
    train = set_train
    wagons_list(train)
  end

  def train_route_menu
    if @trains.any? && @routes.any?
      route = set_route
      train = set_train
      train.assign_route(route)
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
      wagon = choose_wagon(train)

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
    else
      train.move_previous_station
    end
    train_status_message(train)
  end

  def test_accessors
    w = Wagon.new
    puts "Создна новый вагон #{w}"
    w.manufacturer = 'Cola'
    puts "Производитель: #{w.manufacturer}"
    w.manufacturer = 'Pepsi'
    puts "Новый производитель: #{w.manufacturer}"

    puts "История производителей: #{w.manufacturer_history.join(', ')}"

    puts "Тестируем strong accessors допустимый формат #{w.test_strong = 'kslslsl'}"
    puts "Тестируем strong accessors недопустимый формат #{w.test_strong = 333}"
  end
end
