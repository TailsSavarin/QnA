class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  # rubocop:disable Layout/LineLength, Lint/EmptyConditionalBody
  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.zone.now)
    end
    user.create_authorization(auth)

    user
  end
  # rubocop:enable Layout/LineLength, Lint/EmptyConditionalBody
end
