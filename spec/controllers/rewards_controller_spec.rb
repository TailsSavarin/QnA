require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_rewards) { create_list(:reward, 2, user: user) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array(user_rewards)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renvers index view template' do
      expect(response).to render_template :index
    end
  end
end
