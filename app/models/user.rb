class User < ApplicationRecord
  #needs to have a username thats not taken, and a a password thats minimum length of 6
  has_secure_password
  has_many :registrations, dependent: :destroy
  has_many :events, through: :registrations

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true, inclusion: { in: %w[admin user] }

  def admin?
    role == 'admin'
  end
end



