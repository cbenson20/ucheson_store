ActiveAdmin.register Product do
  # Permit parameters for create and update
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :new_arrival, category_ids: []

  # Index page (list view)
  index do
    selectable_column
    id_column
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
  end
end