class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # POST /users (Rubric 3.1.5 - Save address during signup)
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      # Create address from signup form (Rubric 3.1.5)
      if params[:user][:street_address].present?
        resource.addresses.create!(
          street_address: params[:user][:street_address],
          city: params[:user][:city],
          postal_code: params[:user][:postal_code],
          province_id: params[:user][:province_id],
          address_type: 'shipping'
        )
      end

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  # Permit additional parameters (Rubric 3.1.5)
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name,
      :username,
      :street_address,
      :city,
      :postal_code,
      :province_id
    ])
  end
end