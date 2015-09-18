require 'rails_helper'

feature 'home page slider' do

  subject { page }

  context 'as a guest' do
    before { visit home_path }
    it { is_expected.to have_title('Home') }
    it { is_expected.not_to have_content(:link_or_button, 'New Slider Image') }
    it { is_expected.not_to have_content(:link_or_button, 'Edit Slider Images') }
  end

  context 'as a user' do
    let(:user) { create(:user) }
    before { sign_in user }
    before { visit home_path }
  end
  
  context 'as an admin' do

    let(:admin) { create(:admin) }
    let!(:image) { create(:slider_image) }
    before do
      test_sign_in admin
      visit home_path
    end

    scenario 'add image - happy path' do
      find(:link_or_button, 'New Slider Image').click
      fill_in 'Name:', with: 'New image name'
      fill_in 'Caption:', with: 'Awesome! New! Product!'
      fill_in 'Image URL:', with: 'new_image_url'
      fill_in 'Product URL:', with: 'new_product_url'
      fill_in 'Sort Order:', with: '10'
      find(:link_or_button, 'Submit').click
      expect(current_path).to eq slider_images_path
      expect(page).to have_content("Slider image")
      expect(page).to have_content("was successfully created")
    end

    scenario 'edit image - happy path' do
      find(:link_or_button, 'Edit Slider Images').click
      fill_in 'Name:', with: 'New name'
      find(:link_or_button, 'Update').click
      expect(current_path).to eq slider_images_path
      expect(page).to have_content("Slider image")
      expect(page).to have_content("was successfully updated")
    end
    
    scenario 'add image - bad data' do
      find(:link_or_button, 'New Slider Image').click
      fill_in 'Name:', with: 'New image name'
      find(:link_or_button, 'Submit').click
      expect(current_path).to eq slider_images_path
      expect(page).to have_content "Caption can't be blank"
      expect(page).to have_content "Image url can't be blank"
    end

    scenario 'add image - quit' do
      find(:link_or_button, 'New Slider Image').click
      fill_in 'Name:', with: 'New image name'
      find(:link_or_button, 'Quit').click
      expect(current_path).to eq home_path
      expect(page).to have_title "Home"
    end

  end
end
