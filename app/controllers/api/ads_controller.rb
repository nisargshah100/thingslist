class Api::AdsController < Api::ApiController

  def create
    ad = Ad.new(params[:ad])
    ad.user = current_user
    if ad.save()
      current_user.post_ad(@ad)
      respond_with(true)
    else
      respond_with(ad.errors.full_messages)
    end
  end

end
