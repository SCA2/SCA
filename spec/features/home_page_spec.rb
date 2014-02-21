require 'spec_helper'

feature 'home page' do

  before { visit home_path }
  subject { page }
  
  it { should have_title('Home') }

  context 'as a guest' do
    before { visit home_path }
  end

  context 'as a user' do
    let(:user) { create(:user) }
    before { sign_in user }
    before { visit home_path }
  end
  
  context 'as an admin' do
    scenario 'add image to slider', js: false do
      admin = create(:admin)
      sign_in admin
      visit home_path
      expect(page).to_not have_content 'new_photo_url'
      find(:link_or_button, 'Add Image').click
      fill_in 'Name:', with: 'New image name'
      fill_in 'Caption:', with: 'Awesome! New! Product!'
      fill_in 'URL:', with: 'new_image_url'
      click_button "Add Image"
      expect(current_path).to eq slider_image_path(1)
      expect(page).to have_content "Slider image was successfully created."
    end
  end
end
