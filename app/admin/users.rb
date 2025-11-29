ActiveAdmin.register User do
  permit_params :email, :username, :first_name, :last_name

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :first_name
    column :last_name
    column "Number of Orders" do |user|
      user.orders.count
    end
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :first_name
  filter :last_name
  filter :created_at

  form do |f|
    f.inputs "Customer Details" do
      f.input :email
      f.input :username
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :username
      row :first_name
      row :last_name
      row "Full Name" do |user|
        user.full_name
      end
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      table_for user.orders do
        column :id
        column :status do |order|
          status_tag order.status
        end
        column :total do |order|
          number_to_currency(order.total, unit: "₦")
        end
        column :created_at
        column "View" do |order|
          link_to "View Order", admin_order_path(order)
        end
      end
    end

    panel "Addresses" do
      table_for user.addresses do
        column :street_address
        column :city
        column :province do |address|
          address.province.name
        end
        column :postal_code
        column :address_type
      end
    end
  end
end