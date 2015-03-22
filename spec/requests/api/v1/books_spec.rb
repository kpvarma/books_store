require 'rails_helper'

RSpec.describe "Book Store", type: :request do

  context "list /books" do
    it "returns the books API for /books url" do
      # Create 3 new books
      Book.create(name: "The Merchant of venice", author: "William shakespeare", isbn: "9781467758567", description: "The Merchant of Venice is a play by William Shakespeare in which a merchant in 16th century Venice must default on a large loan provided by an abused Jewish moneylender. It is believed to have been written between 1596 and 1598.")
      Book.create(name: "My experiments with Truth", author: "Mahatma Gandhi", isbn: "9781607960201", description: "The Story of My Experiments with Truth is the autobiography of Mohandas K. Gandhi, covering his life from early childhood through to 1921. It was written in weekly instalments and published in his journal Navjivan from 1925 to 1929.")
      Book.create(name: "The Cairo Trilogy", author: "Naguib Mahfouz", isbn: "9780375413315", description: "Naguib Mahfouz's magnificent epic trilogy of colonial Egypt appears here in one volume for the first time. The Nobel Prize--winning writer's masterwork is the engrossing story of a Muslim family in Cairo during Britain's occupation of Egypt in the early decades of the twentieth century.")

      get api_v1_books_url
      expect(response.status).to eq(200)
      response_body = JSON.parse(response.body)
      expect(response_body.length).to eq(3)
      expect(response_body.first.keys).to eq(["id", "name", "author", "isbn", "description"])
    end
  end

  context "post /books - add a new book" do
    context "positive case" do
      it "should add a new book to the database" do
        book_data = {name: "Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life", author: "Spencer Johnson", isbn: "9780939173457", description: "Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life, published on September 8, 1998, is a motivational tale by Spencer Johnson written in the style of a parable or business fable."}
        post api_v1_books_url, book_data
        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body)
        expect(response_body["name"]).to eq(book_data[:name])
        expect(response_body["author"]).to eq(book_data[:author])
        expect(response_body["isbn"]).to eq(book_data[:isbn])
        expect(response_body["description"]).to eq(book_data[:description])
      end
    end

    context "negative case" do
      it "should return errors for invalid data" do
        book_data = {}
        post api_v1_books_url, book_data
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body["errors"]).to be_present
        expect(response_body["errors"]["name"]).to eq(["can't be blank"])
        expect(response_body["errors"]["author"]).to eq(["can't be blank"])
        expect(response_body["errors"]["isbn"]).to eq(["can't be blank"])
      end
    end
  end

  context "put /books/:id - update a book" do
    context "positive case" do
      it "should update an existing book with the new data" do
        book = Book.create(name: "Who Moved My Cheese?", author: "Johnson", isbn: "9780939173457", description: "")
        updated_data = {name: "Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life", author: "Spencer Johnson", isbn: "9780939173457", description: "Who Moved My Cheese? An Amazing Way to Deal with Change in Your Work and in Your Life, published on September 8, 1998, is a motivational tale by Spencer Johnson written in the style of a parable or business fable."}
        put api_v1_book_url(book), updated_data
        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body)
        expect(response_body["name"]).to eq(updated_data[:name])
        expect(response_body["author"]).to eq(updated_data[:author])
        expect(response_body["isbn"]).to eq(updated_data[:isbn])
        expect(response_body["description"]).to eq(updated_data[:description])
      end
    end

    context "negative case" do
      it "should return errors for invalid data" do
        book = Book.create(name: "Who Moved My Cheese?", author: "Johnson", isbn: "9780939173457", description: "")
        updated_data = {name: "", author: "", isbn: ""}
        put api_v1_book_url(book), updated_data
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body["errors"]).to be_present
        expect(response_body["errors"]["name"]).to eq(["can't be blank"])
        expect(response_body["errors"]["author"]).to eq(["can't be blank"])
        expect(response_body["errors"]["isbn"]).to eq(["can't be blank"])
      end
    end
  end

  context "delete /books/:id - delete a book" do
    context "positive case" do
      it "should delete an existing book" do
        book = Book.create(name: "Who Moved My Cheese?", author: "Johnson", isbn: "9780939173457", description: "")
        delete api_v1_book_url(book)
        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body)
        expect(response_body["message"]).to eq("Successfully deleted")
      end
    end

    context "negative case" do
      it "should return errors for invalid data" do
        book = Book.create(name: "Who Moved My Cheese?", author: "Johnson", isbn: "9780939173457", description: "")
        delete api_v1_book_url(id: 1234)
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body["errors"]).to be_present
        expect(response_body["errors"]["id"]).to eq("not found")
      end
    end
  end
end