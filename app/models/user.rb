# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :validatable, :trackable

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validate :password_complexity

  def self.authenticate(user, password)
    user&.valid_password?(password)
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#+('");?!@$%^&*-]).{8,70}$/

    errors.add(:password, :password_complexity)
  end
end
