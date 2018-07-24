require 'rails_helper'
require 'pry'

RSpec.describe "Products API", type: :request do
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'application/vnd.taskmanager.v2',
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe "GET /products" do
    before do
      @category = create(:category)
      @products = create_list(:product, 5, category_id: @category.id)
      get '/api/v1/products', params: {}, headers: headers
    end

    it "return status code 200" do
      expect(response).to have_http_status(200)
    end

    it 'return a 5 products from database' do
      expect(assigns(:products).count).to be > 5
    end
  end
end
