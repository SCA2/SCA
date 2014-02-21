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
    scenario 'add image to slider' do
      admin = create(:admin)
      sign_in admin
      visit home_path
      expect(page).to_not have_content 'new_photo_url'
      click_button "Add Image"
      fill_in 'URL:', with: 'new_photo_url'
      fill_in 'Caption:', with: 'Awesome! New! Product!'
      click_button "Add Image"
      expect(current_path).to eq home_path
      expect(page).to have_content "Success!"
    end
  end
end
