class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :author, :isbn, :description
end
