class CashflowsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cashflows = current_user.cashflows.active # Show only active (not soft-deleted) cashflows
  end

  def new
    @cashflow = Cashflow.new
  end

  def create
    @cashflow = current_user.cashflows.build(income_params)

    if @cashflow.save
      redirect_to cashflows_path, notice: "Cashflow added successfully!"
    else
      render :new
    end
  end

  def edit
    @cashflow = current_user.cashflows.find(params[:id])
  end

  def update
    @cashflow = current_user.cashflows.find(params[:id])

    if @cashflow.update(income_params)
      redirect_to cashflows_path, notice: "Cashflow updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @cashflow = current_user.cashflows.find(params[:id])
    @cashflow.soft_delete
    redirect_to cashflows_path, notice: "Cashflow marked as deleted!"
  end

  private

  def income_params
    params.require(:cashflow).permit(:amount, :description, :date)
  end
end
