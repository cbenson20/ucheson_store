class Account::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = current_user.addresses.build
    @provinces = Province.all.order(:name)
  end

  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      flash[:notice] = "Address added successfully."
      redirect_to account_addresses_path
    else
      @provinces = Province.all.order(:name)
      render :new
    end
  end

  def edit
    @provinces = Province.all.order(:name)
  end

  def update
    if @address.update(address_params)
      flash[:notice] = "Address updated successfully."
      redirect_to account_addresses_path
    else
      @provinces = Province.all.order(:name)
      render :edit
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = "Address deleted successfully."
    redirect_to account_addresses_path
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:street_address, :city, :postal_code, :province_id, :address_type)
  end
end