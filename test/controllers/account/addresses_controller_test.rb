require "test_helper"

class Account::AddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get account_addresses_index_url
    assert_response :success
  end

  test "should get new" do
    get account_addresses_new_url
    assert_response :success
  end

  test "should get edit" do
    get account_addresses_edit_url
    assert_response :success
  end

  test "should get create" do
    get account_addresses_create_url
    assert_response :success
  end

  test "should get update" do
    get account_addresses_update_url
    assert_response :success
  end

  test "should get destroy" do
    get account_addresses_destroy_url
    assert_response :success
  end
end
