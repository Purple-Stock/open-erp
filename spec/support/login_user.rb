module LoginUser
  def login_user(user = create(:user))
    login_as user, scope: :user
    user
  end
end
