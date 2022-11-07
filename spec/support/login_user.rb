# frozen_string_literal: true

module LoginUser
  def login_user(user = create(:user))
    login_as user, scope: :user
    user
  end
end
