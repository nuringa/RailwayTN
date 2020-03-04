require_relative 'train'
require_relative 'station'
require_relative 'route'

#тест классов
station1 = Station.new('First')
station2 = Station.new('Last')
station3 = Station.new('Mid2')
station4 = Station.new('Mid3')
station5 = Station.new('Mid4')

# p station1

route = Route.new(station1, station2)
route.add_midway_station(station3)
route.add_midway_station(station4)
route.add_midway_station(station5)


train1 = Train.new(111, 'cargo', 13)
train2 = Train.new(222, 'passenger', 5)


# модель Train
train1.set_route(route)

p 'first station'
p train1.current_stop.name

p 'step forward'
train1.move_train('next')
p train1.current_stop.name
p 'delete train from prev station'
p station1
p 'add train to next station'
p route.route_list[1]

train1.move_train('next')
p train1.current_stop.name

train1.move_train('next')
p train1.current_stop.name

train1.move_train('back')
p train1.current_stop.name

train1.move_train('next')
p train1.current_stop.name

train1.move_train('next')
p train1.current_stop.name

p train1.current_stop.name
p train1.next_stop
p train1.previous_stop

#модель Route
# p route.route_list
# route.delete_midway_station(station3)
# p route.route_list
# route.add_midway_station(station3)
# route.add_midway_station(station3)
# p route.route_list

#модель Станции
# station1.add_train(train1)
# station1.add_train(train2)
# p station1.trains.count
#
# puts 'Trains'
# p station1.trains
# puts 'Cargo'
# p station1.cargo_trains
# puts 'Passenger'
# p station1.passanger_trains
#
# station1.send_train(train1)
# p station1.trains
