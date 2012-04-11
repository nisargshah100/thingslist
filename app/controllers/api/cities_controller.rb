class Api::CitiesController < Api::ApiController

  def index
    respond_with(City.includes(:state).all)
  end

  def nearby
    required :city, :state
    defaults :limit => 10, :distance => 30

    state = State.any_of({:name => @state}, {:abbr => @state}).first
    city = City.where(:name => @city, :state_id => state.id).first
    cities = city.find_closest(@distance).limit(@limit)

    respond_with(cities)
  end

end
