class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :show, :destroy]

    def index
        @products = Product.all
    end

    def new
        @product = Product.new
    end

    def show
    end

    def edit
    end

    def create
        @product = Product.new(product_params)

        if @product.save
            flash[:success] = 'Product was successfully created'
            redirect_to action: :index
        else
            flash.now[:error] = @product.errors.messages
            render :new
        end
    end

    def update
        if @product.update(product_params)
            flash[:success] = 'Product was successfully updated'
            redirect_to action: :index
        else
            flash.now[:error] = @product.errors.messages
            render :edit
        end
    end

    def destroy
        if @product.destroy
            flash[:success] = 'Product was successfully destroyed'
            redirect_to action: :index
        else
            flash.now[:error] = @product.errors.messages
            render :index
        end
    end

    private
    def set_product
        @product = Product.find(params[:id])
    end

    def product_params
        params.require(:product).permit(:name, :description, :price, :category_id)
    end
end
