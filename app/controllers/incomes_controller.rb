class IncomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @incomes = current_user.incomes.active # Show only active (not soft-deleted) incomes
  end

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.build(income_params)

    if @income.save
      redirect_to incomes_path, notice: "Income added successfully!"
    else
      render :new
    end
  end

  def edit
    @income = current_user.incomes.find(params[:id])
  end

  def update
    @income = current_user.incomes.find(params[:id])

    if @income.update(income_params)
      redirect_to incomes_path, notice: "Income updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @income = current_user.incomes.find(params[:id])
    @income.soft_delete
    redirect_to incomes_path, notice: "Income marked as deleted!"
  end

  private

  def income_params
    params.require(:income).permit(:amount, :description, :date)
  end
end
