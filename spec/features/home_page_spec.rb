require 'rails_helper'

feature 'home page slider' do

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
    scenario 'add image - happy path', js: false do
      admin = create(:admin)
      sign_in admin
      visit home_path
      expect(page).to_not have_content 'new_image_url'
      find(:link_or_button, 'New Slider Image').click
      fill_in 'Name:', with: 'New image name'
      fill_in 'Caption:', with: 'Awesome! New! Product!'
      fill_in 'Image URL:', with: 'new_image_url'
      fill_in 'Product URL:', with: 'new_product_url'
      fill_in 'Sort Order:', with: '10'
      save_and_open_page
      find(:link_or_button, 'Submit').click
      expect(current_path).to eq home_path #slider_image_path(1)
      expect(page).to have_content "Slider image was successfully created."
    end
    
    # scenario 'add image - bad data', js: false do
    #   admin = create(:admin)
    #   sign_in admin
    #   visit home_path
    #   expect(page).to have_content 'New Slider Image'
    #   find(:link_or_button, 'New Slider Image').click
    #   fill_in 'Name:', with: 'New image name'
    #   find(:link_or_button, 'Create').click
    #   expect(current_path).to eq slider_images_path
    #   expect(page).to have_content "Caption can't be blank"
    #   expect(page).to have_content "Url can't be blank"
    # end

    # scenario 'add image - quit', js: false do
    #   admin = create(:admin)
    #   sign_in admin
    #   visit home_path
    #   expect(page).to_not have_content 'new_image_url'
    #   find(:link_or_button, 'New Slider Image').click
    #   fill_in 'Name:', with: 'New image name'
    #   find(:link_or_button, 'Quit').click
    #   expect(current_path).to eq slider_images_path
    #   expect(page).to have_title "Home"
    # end

    # scenario 'edit image - happy path', js: false do
    #   admin = create(:admin)
    #   sign_in admin
    #   visit home_path
    #   expect(page).to have_content 'Edit Slider Images'
    #   find(:link_or_button, 'Edit Slider Images').click
    #   # fill_in 'Name:', with: 'New image name'
    #   # fill_in 'Caption:', with: 'Awesome! New! Product!'
    #   # fill_in 'URL:', with: 'new_image_url'
    #   # find(:link_or_button, 'Create').click
    #   # expect(current_path).to eq slider_image_path(1)
    #   # expect(page).to have_content "Slider image was successfully created."
    # end
  end
end
