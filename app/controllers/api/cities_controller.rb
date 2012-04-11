class Api::CitiesController < Api::ApiController

  def index
    cities = City.only(:name)
    respond_with(cities)
  end

  def nearby
    required :city, :state
    defaults :limit => 10, :distance => 30

    state = State.any_of({:name => @state}, {:abbr => @state}).first
    city = City.where(:name => @city, :state_id => state.id).first

    render :json => city.find_closest(@distance).limit(@limit)
  end

end
