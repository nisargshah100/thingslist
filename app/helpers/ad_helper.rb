module AdHelper

  def price_to_text(price)
    if price.cents == 0
      "Free"
    else
      "$#{price}"
    end
  end

  def quality_to_text(quality)
    if quality.blank?
      "-"
    else
      quality.titlecase
    end
  end

end
