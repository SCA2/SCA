require 'rails_helper'

describe UsersController do

  describe "submitting to the update action" do
    before { patch user_path(user) }
    specify { expect(response).to redirect_to(signin_path) }
  end
  
  describe "as wrong user" do

    let(:user) { create(:user) }
    let(:wrong_user) { create(:user, email: "wrong@example.com") }

    before { test_sign_in user }
    
    describe "submitting a GET request to the Users#edit action" do
      before { get edit_user_path(wrong_user) }
      specify { expect(response.body).not_to match('Edit user') }
      specify { expect(response).to redirect_to(root_path) }
    end
    
    describe "submitting a PUT request to the Users#update action" do
      before { put user_path(wrong_user) }
      specify { expect(response).to redirect_to(root_path) }
    end

  end
  
  describe "as non-admin user" do

    let(:non_admin) { create(:user) }

    before { test_sign_in non_admin }

    describe "submitting a DELETE request to the Users#destroy action", :type => :controller do
      before { delete user_path(non_admin) }
      specify { expect(response).to redirect_to(root_path) }
    end
  end


end
