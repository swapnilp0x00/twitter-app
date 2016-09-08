require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "index including pagination" do
   log_in_as(@user)
   get users_path
   assert_template 'users/index'
   assert_select 'div.pagination'
   User.paginate(page: 1).each do |user|
     assert_select 'a[href=?]', user_path(user), text: user.name
   end
 end

end