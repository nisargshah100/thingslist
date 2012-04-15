class Api::AdsController < Api::ApiController

  def new
    ad = Ad.new(params[:ad])
    ad.user = current_user
    if ad.save()
      respond_with(true)
    else
      respond_with(ad.errors.full_messages)
    end
  end

end
