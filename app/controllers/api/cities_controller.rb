class Api::CitiesController < Api::ApiController

  def search
    required :city
    defaults :limit => 10
    @limit = 10 if @limit > 10 or @limit < 1

    cities = City.where(:name => /#{@city}/).includes(:state).limit(@limit)
    #cities = City.fulltext_search(@city, { :max_results => @limit })

    respond_with(cities)
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
