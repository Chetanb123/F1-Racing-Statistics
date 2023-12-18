filter_data = function(data, racer, year, position) {
  filter(data, driverRef == racer, year == year, position == position)
}