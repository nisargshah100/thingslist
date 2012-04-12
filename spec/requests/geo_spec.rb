require 'spec_helper'

describe 'Geo Redirection' do
  it 'server is up' do
    visit '/'
    page.status_code.should be 200
  end

  it 'redirects to closest city' do
    visit '/'
    page.should have_content 'washington, dc'
  end
end