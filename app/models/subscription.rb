# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :event, presence: true
  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: -> { user.present? }
  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }
  validate :subscription_to_own_event
  validate :email_already_exist

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def subscription_to_own_event
    errors.add(:base, I18n.t('error.subscriptions.own_event')) if user.present? && event.user == user
  end

  def email_already_exist
    return unless !user.present? && User.exists?(email: user_email)

    errors.add(:user_email,
               I18n.t('error.subscriptions.email_already_exist'))
  end
end
