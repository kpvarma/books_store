class Book < ActiveRecord::Base

  # Validations
  # -----------

  validates :name, presence: true, length: {minimum: 3, maximum: 256}
  validates :author, presence: true, length: {minimum: 3, maximum: 256}
  validates :isbn, presence: true, length: {minimum: 10, maximum: 32}

end
