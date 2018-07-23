class Api::V1::ProductsController < Api::V1::ApiController
    before_action :set_product, only: [:update, :show, :destroy]
    respond_to :json

    def index
        @products = Product.all
        respond_with @products
    end

    def show
        begin
            respond_with @product
        rescue
            head 404
        end
    end

    def create
        @product = Product.new(product_params)

        if @product.save
            render json: @product, status: 201
        else
            render json: { errors: @product.errors }, status: 422
        end
    end

    def update
        if @product.update(product_params)
            render json: @product, status: 201
        else
            render json: { errors: @product.errors }, status: 422
        end
    end

    def destroy
        if @product.destroy
            head 204
        else
            render json: { errors: @product.errors }, status: 422
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
