ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description do |category|
      truncate(category.description, length: 100)
    end
    column "Number of Products" do |category|
      category.products.count
    end
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description, as: :text, input_html: { rows: 5 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row "Number of Products" do |category|
        category.products.count
      end
      row :created_at
      row :updated_at
    end

    panel "Products in this Category" do
      table_for category.products do
        column :id
        column :name
        column :price do |product|
          number_to_currency(product.price, unit: "₦")
        end
        column :stock_quantity
        column "View" do |product|
          link_to "View", admin_product_path(product)
        end
      end
    end
  end
end