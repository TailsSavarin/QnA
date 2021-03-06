class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :validatable,
         :recoverable,
         :confirmable,
         :registerable,
         :rememberable,
         :omniauthable,
         :database_authenticatable,
         omniauth_providers: %i[github facebook]

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def voted_for?(resource)
    resource.votes.exists?(user_id: id)
  end

  def subscribed_to?(question)
    subscriptions.exists?(question_id: question)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
