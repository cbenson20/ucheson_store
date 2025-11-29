class ProductsController < ApplicationController
  # Front page - show all products (Rubric 2.1)
  def index
    @products = Product.includes(:categories, images_attachments: :blob).order(created_at: :desc)
    @categories = Category.all
  end

  # Product detail page (Rubric 2.3)
  def show
    @product = Product.includes(:categories, images_attachments: :blob).find(params[:id])
  end

  # Browse by category (Rubric 2.2)
  def category
    @category = Category.find(params[:category_id]) if params[:category_id].present?

    if @category
      @products = @category.products.includes(:categories, images_attachments: :blob).order(created_at: :desc)
    else
      @products = Product.includes(:categories, images_attachments: :blob).order(created_at: :desc)
    end

    @categories = Category.all
    render :index
  end
end