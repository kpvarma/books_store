class Book < ActiveRecord::Base

  # Validations
  # -----------

  validates :name, presence: true
  validates :author, presence: true
  validates :isbn, presence: true

  # Instance Methods
  # ----------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    options[:except] = [:created_at, :updated_at]
    super(options)
  end

end
