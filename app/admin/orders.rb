ActiveAdmin.register Order do
  permit_params :status, :payment_id

  index do
    selectable_column
    id_column
    column "Customer" do |order|
      order.user.full_name
    end
    column :status do |order|
      status_tag order.status
    end
    column :subtotal do |order|
      number_to_currency(order.subtotal, unit: "₦")
    end
    column :tax_amount do |order|
      number_to_currency(order.tax_amount, unit: "₦")
    end
    column :total do |order|
      number_to_currency(order.total, unit: "₦")
    end
    column :created_at
    actions
  end

  filter :status, as: :select, collection: ['pending', 'paid', 'shipped', 'delivered', 'cancelled']
  filter :user
  filter :created_at

  form do |f|
    f.inputs "Order Status" do
      f.input :status, as: :select, collection: ['pending', 'paid', 'shipped', 'delivered', 'cancelled']
      f.input :payment_id, hint: "Payment ID from Stripe/PayPal (if applicable)"
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row "Customer" do |order|
        link_to order.user.full_name, admin_user_path(order.user)
      end
      row "Customer Email" do |order|
        order.user.email
      end
      row :status do |order|
        status_tag order.status
      end
      row "Shipping Address" do |order|
        address = order.address
        "#{address.street_address}, #{address.city}, #{address.province.name} #{address.postal_code}"
      end
      row :subtotal do |order|
        number_to_currency(order.subtotal, unit: "₦")
      end
      row :tax_amount do |order|
        number_to_currency(order.tax_amount, unit: "₦")
      end
      row :total do |order|
        number_to_currency(order.total, unit: "₦")
      end
      row :payment_id
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column "Product" do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column :quantity
        column "Price at Purchase" do |item|
          number_to_currency(item.price_at_purchase, unit: "₦")
        end
        column "Line Total" do |item|
          number_to_currency(item.line_total, unit: "₦")
        end
      end
    end
  end
end