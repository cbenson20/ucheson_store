ActiveAdmin.register Province do
  permit_params :name, :code, :gst_rate, :pst_rate, :hst_rate

  index do
    selectable_column
    id_column
    column :name
    column :code
    column "GST Rate" do |province|
      number_to_percentage(province.gst_rate * 100, precision: 2)
    end
    column "PST Rate" do |province|
      number_to_percentage(province.pst_rate * 100, precision: 2)
    end
    column "HST Rate" do |province|
      number_to_percentage(province.hst_rate * 100, precision: 2)
    end
    column "Total Tax" do |province|
      number_to_percentage(province.total_tax_rate * 100, precision: 2)
    end
    actions
  end

  filter :name
  filter :code

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code, hint: "2-letter province code (e.g., ON, BC)"
    end

    f.inputs "Tax Rates (as decimals: 0.05 = 5%)" do
      f.input :gst_rate, hint: "Goods and Services Tax"
      f.input :pst_rate, hint: "Provincial Sales Tax"
      f.input :hst_rate, hint: "Harmonized Sales Tax"
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :code
      row "GST Rate" do |province|
        number_to_percentage(province.gst_rate * 100, precision: 4)
      end
      row "PST Rate" do |province|
        number_to_percentage(province.pst_rate * 100, precision: 4)
      end
      row "HST Rate" do |province|
        number_to_percentage(province.hst_rate * 100, precision: 4)
      end
      row "Total Tax Rate" do |province|
        number_to_percentage(province.total_tax_rate * 100, precision: 2)
      end
      row :created_at
      row :updated_at
    end
  end
end