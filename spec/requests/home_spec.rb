require 'spec_helper'

describe 'Home' do
  it 'server is up' do
    visit '/'
    page.status_code.should be 200
  end

  it 'redirects to closest city' do
    visit '/'
    page.should have_content 'washington, DC'
  end
end