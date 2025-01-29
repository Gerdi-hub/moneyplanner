class KeywordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_keyword, only: %i[edit update destroy]

  def index
    @keywords = Keyword.all
  end

  def new
    @keyword = Keyword.new
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      update_cashflows
      redirect_to keywords_path, notice: "Keyword added successfully!"
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @keyword.update(keyword_params)
      redirect_to keywords_path, notice: "Keyword updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @keyword.destroy
    redirect_to keywords_path, notice: "Keyword deleted successfully!"
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:id])
  end

  def keyword_params
    params.require(:keyword).permit(:name, :type_name)
  end

  def update_cashflows
    all_cashflows = Cashflow.where(type_name: nil)
    all_cashflows.each do |cashflow|
      cashflow.save
    end
  end
end
