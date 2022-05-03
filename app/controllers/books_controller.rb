class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @booknew = Book.new
  end

  def index
    @books = Book.all
    @booknew = Book.new
  end

  def create
    @booknew = Book.new(book_params)
    @booknew.user_id = current_user.id
    # 上の定義がないとuserが無いと出る。とは、bookカラムにはuser_idがあってそれが誰なのかを決めないと保存できないから。
    # userのバリデーションが反応したわけではない！
    if @booknew.save
      redirect_to book_path(@booknew), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
   @book = Book.find(params[:id])
   unless @book.user == current_user
     redirect_to books_path
   end
  end

end
