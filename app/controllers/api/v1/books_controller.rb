class Api::V1::BooksController < ApplicationController

  def index
    @books = Book.all
    render :json => @books, :status => 200
  end

  def show
    @book = Book.find_by_id(params[:id])
    render :json => @book, root: :book, :status => 200
  end

  def create
    @book = Book.new(book_params)
    #binding.pry
    if @book.valid?
      @book.save
      render json: @book, status: 201
    else
      render json: {errors: @book.errors}, status: 422
    end
  end

  def update
    @book = Book.find_by_id(params[:id])
    @book.assign_attributes(book_params)
    if @book.valid?
      @book.save
      render json: @book, status: 201
    else
      render json: {errors: @book.errors}, status: 422
    end
  end

  def destroy
    @book = Book.find_by_id(params[:id])
    if @book
      @book.destroy
      render json: {message: "Successfully deleted"}, status: 201
    else
      render json: {errors: {id: "not found"}}, status: 422
    end
  end

  private
  def book_params
    params.require(:book).permit(:name, :author, :isbn, :description)
  end

end