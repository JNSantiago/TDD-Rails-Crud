require 'rails_helper'
require 'pry'

RSpec.describe "Products API", type: :request do
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'ACCEPT' => 'application/json',
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

  describe "POST /products" do
    before do
      category = create(:category)
      @product_params = attributes_for(:product, category_id: category.id)
      post "/api/v1/products", params: { product: @product_params }.to_json, headers: headers
    end

    it "return status code 201" do
      expect(response).to have_http_status(201)
    end

    it 'return a product created from database' do
      expect( Product.find_by(name: @product_params[:name]) ).not_to be_nil
    end
  end

  describe "PUT /products" do
    before do
      @product_params = Product.first
      @product_params.name = "ATUALIZADO"
      patch "/api/v1/products/#{@product_params.id}", params: { product: @product_params.attributes }.to_json, headers: headers
    end

    it "return status code 200" do
      expect(response).to have_http_status(200)
    end

    it 'return a product from database' do
      expect( Product.find_by(name: @product_params[:name]) ).not_to be_nil
    end
  end

  describe "DELETE /products" do
    before do
      @product = Product.first
      delete "/api/v1/products/#{@product.id}", headers: headers
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it 'remove one register from database' do
      expect { Product.find(@product.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
