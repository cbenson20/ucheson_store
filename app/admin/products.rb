ActiveAdmin.register Product do
  # Permit parameters for create and update (including images)
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :new_arrival,
                category_ids: [], images: []

  # Index page (list view)
  index do
    selectable_column
    id_column
    column "Image" do |product|
      if product.images.attached? && product.images.first.present?
        image_tag url_for(product.images.first), size: "50x50", style: "object-fit: cover;"
      else
        content_tag :span, "No image", style: "color: #999;"
      end
    end
    column :name
    column :price do |product|
      number_to_currency(product.price, unit: "₦")
    end
    column :stock_quantity
    column :on_sale
    column :new_arrival
    column "Categories" do |product|
      product.categories.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  # Filter sidebar
  filter :name
  filter :price
  filter :stock_quantity
  filter :on_sale
  filter :new_arrival
  filter :categories
  filter :created_at

  # Form for creating/editing
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :text, input_html: { rows: 5 }
      f.input :price, hint: "Price in Nigerian Naira (₦)"
      f.input :stock_quantity
      f.input :on_sale, as: :boolean
      f.input :new_arrival, as: :boolean
    end

    f.inputs "Categories" do
      f.input :categories, as: :check_boxes, collection: Category.all
    end

    f.inputs "Product Images" do
      if f.object.images.attached?
        f.object.images.each do |image|
          div do
            span image_tag(url_for(image), size: "150x150", style: "object-fit: cover; margin: 10px;")
            span link_to "Remove",
                         delete_image_admin_product_path(f.object, image_id: image.id),
                         method: :delete,
                         data: { confirm: "Are you sure?" },
                         style: "color: red; margin-left: 10px;"
          end
        end
      end
      f.input :images, as: :file, input_html: { multiple: true },
              hint: "You can select multiple images at once. JPG, PNG, or WEBP files recommended."
    end

    f.actions
  end

  # Show page (detail view)
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price do |product|
        number_to_currency(product.price, unit: "₦")
      end
      row :stock_quantity
      row :on_sale
      row :new_arrival
      row "Categories" do |product|
        product.categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end

    panel "Product Images" do
      if product.images.attached?
        product.images.each do |image|
          div style: "display: inline-block; margin: 10px;" do
            image_tag url_for(image), size: "200x200", style: "object-fit: cover; border: 1px solid #ddd; padding: 5px;"
          end
        end
      else
        para "No images uploaded yet"
      end
    end
  end

  # Custom action to delete individual images
  member_action :delete_image, method: :delete do
    image = resource.images.find(params[:image_id])
    image.purge
    redirect_to admin_product_path(resource), notice: "Image removed successfully"
  end

  # Handle image uploads on create/update
  controller do
    def update
      if params[:product][:images].present?
        # Add new images without removing old ones
        params[:product][:images].each do |image|
          resource.images.attach(image) if image.present?
        end
        params[:product].delete(:images) # Remove from params to avoid duplication
      end
      update! # Call the default update action
    end

    def create
      if params[:product][:images].present?
        # Store images temporarily
        images = params[:product][:images]
        params[:product].delete(:images)

        # Create the product first
        @product = Product.new(permitted_params[:product])

        if @product.save
          # Then attach the images
          images.each do |image|
            @product.images.attach(image) if image.present?
          end
          redirect_to admin_product_path(@product), notice: "Product created successfully"
        else
          render :new
        end
      else
        create! # Call the default create action
      end
    end
  end
end