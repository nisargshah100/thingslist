require 'spec_helper'

describe 'Home' do

  context '#index' do
    before(:each) do
      visit '/'
    end

    it 'server is up' do
      page.status_code.should be 200
    end

    it 'redirects to closest city' do
      page.should have_content 'washington, dc'
    end

    it 'has all the categories' do
      Category.all.each do |c|
        page.should have_content(c.name)
      end
    end
  end

end