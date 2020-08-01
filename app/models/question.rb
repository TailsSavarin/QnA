class Question < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  include Authorable
  include Commentable

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
