require_relative 'lib/instance_counter'
require_relative 'lib/manufacturer'
require_relative 'lib/train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_train'
require_relative 'lib/wagon'
require_relative 'lib/cargo_wagon'
require_relative 'lib/passenger_wagon'
require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'menu_printer'
require_relative 'menu_controller'
require_relative 'seed'

menu = MenuController.new

loop do
  main_menu
  menu.menu_choice
end
