class ProductsController < ApplicationController
  # Front page - show all products with filtering, search, and pagination (Rubric 2.1, 2.4, 2.5, 2.6)
  def index
    @products = Product.includes(:categories, images_attachments: :blob)
    @categories = Category.all

    # Apply category filter if present (Rubric 2.2)
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end

    # Apply search filter (Rubric 2.6)
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where(
        "LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?",
        search_term,
        search_term
      )
    end

    # Apply special filters (Rubric 2.4)
    case params[:filter]
    when 'on_sale'
      @products = @products.where(on_sale: true)
    when 'new'
      @products = @products.where("products.created_at >= ?", 3.days.ago)
    when 'recently_updated'
      @products = @products.where("products.updated_at >= ? AND products.created_at < ?", 3.days.ago, 3.days.ago)
    end

    # Apply pagination (Rubric 2.5)
    @products = @products.order(created_at: :desc).page(params[:page])
  end

  # Product detail page (Rubric 2.3)
  def show
    @product = Product.includes(:categories, images_attachments: :blob).find(params[:id])
    @categories = Category.all
  end

  # Browse by category (Rubric 2.2)
  def category
    @category = Category.find(params[:category_id]) if params[:category_id].present?

    if @category
      @products = @category.products.includes(:categories, images_attachments: :blob)
    else
      @products = Product.includes(:categories, images_attachments: :blob)
    end

    # Apply search if present
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where(
        "LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?",
        search_term,
        search_term
      )
    end

    # Apply special filters
    case params[:filter]
    when 'on_sale'
      @products = @products.where(on_sale: true)
    when 'new'
      @products = @products.where("products.created_at >= ?", 3.days.ago)
    when 'recently_updated'
      @products = @products.where("products.updated_at >= ? AND products.created_at < ?", 3.days.ago, 3.days.ago)
    end

    @products = @products.order(created_at: :desc).page(params[:page])
    @categories = Category.all
    render :index
  end
end