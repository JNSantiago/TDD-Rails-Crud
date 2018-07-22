require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    describe 'as a logged User' do
        before do
            sign_in @user = create(:user)
            @product = create(:product)
            @category = create(:category)
            @category.products << @product
        end

        context 'Testing Routes' do
            it { is_expected.to route(:get, '/products').to(action: :index) }
            it { is_expected.to route(:post, '/products').to(action: :create) }
            it { is_expected.to route(:get, '/products/new').to(action: :new) }
            it { is_expected.to route(:get, '/products/1/edit').to(action: :edit, id: 1) }
            it { is_expected.to route(:get, '/products/1').to(action: :show, id: 1) }
            it { is_expected.to route(:put, '/products/1').to(action: :update, id: 1) }
            it { is_expected.to route(:patch, '/products/1').to(action: :update, id: 1) }
            it { is_expected.to route(:delete, '/products/1').to(action: :destroy, id: 1) }
        end

        describe "GET #index" do
            it "populates an array of products" do
                get :index
                expect(assigns(:products)).to include(@product)
            end

            it "renders the :index view" do
                get :index
                expect(response).to render_template(:index)
            end
        end

        describe "GET #show" do
            it "assigns the requested product to @product" do
                get :show, params: { id: @product.id }
                expect(assigns(:product)).to eq(@product)
            end
            
            it "renders the #show view" do
                get :show, params: { id: @product.id }
                expect(response).to render_template(:show)
            end
        end

        describe "GET #new" do
            it "assigns the requested product to @product" do
                get :new
                expect(assigns(:product)).to be_a_new(Product)
            end
            
            it "renders the #new view" do
                get :new
                expect(response).to render_template(:new)
            end
        end

        describe "POST create" do
            context "with valid attributes" do
              it "creates a new product" do
                expect{
                  post :create, params: { product: attributes_for(:product, category_id: @category.id) }
                }.to change(Product,:count).by(1)
              end
              
              it "redirects to the index product" do
                post :create, params: { product: attributes_for(:product, category_id: @category.id) }
                expect(response).to redirect_to(products_path)
              end

              it "flash success" do
                post :create, params: { product: attributes_for(:product, category_id: @category.id) }
                expect(flash[:success]).to match(/Product was successfully created/)
              end
            end
            
            context "with invalid attributes" do
              it "does not save the new product" do
                    expect{
                        post :create, params: { product: attributes_for(:product, name: nil) }
                    }.not_to change(Product,:count)
              end
              
              it "re-renders the new method" do
                post :create, params: { product: attributes_for(:product, name: nil) }
                expect(response).to render_template(:new)
              end

              it "flash error" do
                post :create, params: { product: attributes_for(:product, name: nil) }
                expect(flash[:error]).not_to be_nil
              end
            end 
        end

        describe 'PUT update' do
            context "valid attributes" do
              it "located the requested @product" do
                put :update, params: { id: @product.id, product: { name: 'New Food Name' } }
                expect(assigns(:product)).to eq(@product)      
              end

              it "changes @product's attributes" do
                new_name = Faker::Food.dish
                put :update, params: { id: @product.id, product: { name: new_name } }
                @product.reload
                expect(@product.name).to eq(new_name)
              end

              it "redirects to the updated product" do
                put :update, params: { id: @product.id, product: { name: 'New Food Name' } }
                expect(response).to redirect_to(products_path)
              end

              it "flash success" do
                put :update, params: { id: @product.id, product: { name: 'New Food Name' } }
                expect(flash[:success]).to match(/Product was successfully updated/)
              end
            end

            context "invalid attributes" do
                it "located the requested @product" do
                    put :update, params: { id: @product.id, product: { name: nil } }
                    expect(assigns(:product)).to eq(@product)      
                end
                
                it "does not change @product's attributes" do
                    new_name = Faker::Food.dish
                    put :update, params: { id: @product.id, product: { name: new_name, price: nil } }
                    @product.reload
                    expect(@product.name).not_to eq(new_name)
                end

                it "re-renders the edit method" do
                    put :update, params: { id: @product.id, product: { name: nil } }
                    expect(response).to render_template(:edit)
                end

                it "flash error" do
                    put :update, params: { id: @product.id, product: { name: nil } }
                    expect(flash[:error]).not_to be_nil
                end
            end
        end

        describe 'DELETE destroy' do
            it "located the requested @product" do
                delete :destroy, params: { id: @product.id }
                expect(assigns(:product)).to eq(@product)      
            end

            it "deletes the contact" do
              expect{
                delete :destroy, params: { id: @product.id }     
              }.to change(Product,:count).by(-1)
            end
              
            it "redirects to products#index" do
              delete :destroy, params: { id: @product.id }
              expect(response).to redirect_to(products_path)
            end

            it "flash success" do
                delete :destroy, params: { id: @product.id }
                expect(flash[:success]).to match(/Product was successfully destroyed/)
            end
        end
    end
end
