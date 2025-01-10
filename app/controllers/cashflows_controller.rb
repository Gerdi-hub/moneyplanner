class CashflowsController < ApplicationController
  require 'csv'
  before_action :authenticate_user!

  def index
    @current_user = current_user
    @user_cashflows = current_user.cashflows.active
    # Get all available years from cashflow records
    @available_years = @user_cashflows.distinct.pluck(Arel.sql("strftime('%Y', date)")).sort.reverse
    @available_months = @user_cashflows.distinct.pluck(Arel.sql("strftime('%m-%Y', date)")).sort.reverse.map { |month| Date.strptime(month, "%m-%Y") }


    # If years are selected, filter the data
    if params[:years].present?
      @selected_years = params[:years]
      @cashflows = @user_cashflows.where(Arel.sql("strftime('%Y', date) IN (?)"), @selected_years)
    else
      @selected_years = []
      @cashflows = @user_cashflows.all
    end

    if params[:months].present?
      @selected_months = params[:months]
      @cashflows = @user_cashflows.where(Arel.sql("strftime('%m-%Y', date) IN (?)"),  @selected_months)
    else
      @selected_months = []
      @cashflows = @user_cashflows.all
    end

    # Group the cashflows by month
    @monthly_data = @cashflows.group_by do |cashflow|
      cashflow.date.strftime("%m-%Y")
    end.transform_values do |cashflows|
      # Group by type and calculate sums
      types_data = cashflows.group_by(&:type_name).transform_values do |grouped_cashflows|
        grouped_cashflows.sum(&:amount)
      end
    end
    end

  def new
    @cashflow = Cashflow.new
  end

  def create
    @cashflow = current_user.cashflows.build(cashflow_params)

    if @cashflow.save
      redirect_to cashflows_path, notice: "Cashflow added successfully!"
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @cashflow = current_user.cashflows.find(params[:id])
  end

  def update
    @cashflow = current_user.cashflows.find(params[:id])

    if @cashflow.update(cashflow_params)
      redirect_to cashflows_path, notice: "Cashflow updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @cashflow = current_user.cashflows.find(params[:id]) # Corrected to `cashflows`
    @cashflow.soft_delete
    redirect_to cashflows_path, notice: "Cashflow marked as deleted!"
  end

  def import
    if params[:file].blank?
      return redirect_to root_path, alert: "Please upload a file"
    else
      Rails.logger.debug "File present: #{params[:file].inspect}"
    end


    file = params[:file]
    process_csv(file)
  end

  private

  def cashflow_params
    params.require(:cashflow).permit(:amount, :description, :date, :type_name) # Updated method name
  end

  def process_csv(file)
    Rails.logger.debug "Started processing CSV file"

    begin
      csv_options = { col_sep: ";", headers: true, encoding: "r:bom|utf-8" }
      first_row = CSV.open(file.path, "r", **csv_options).first
      headers = first_row&.headers

      raise "Could not determine bank format from CSV headers" if headers.nil?

      if headers.include?("Deebet/Kreedit (D/C)") # SEB format
        process_csv_rows(file, csv_options, bank: :seb)
      elsif headers.include?("Tehingu tüüp") # Swedbank format
        process_csv_rows(file, csv_options, bank: :swedbank)
      else
        raise "Unsupported CSV format"
      end

      redirect_to cashflows_path, notice: "CSV imported successfully"
    rescue => e
      redirect_to root_path, alert: "Error importing CSV: #{e.message}"
    end
  end

  private

  def process_csv_rows(file, csv_options, bank:)
    CSV.foreach(file.path, "r", **csv_options) do |row|
      next if row.any?(&:nil?) # Skip rows with nil values
      Rails.logger.debug "Processing row: #{row.inspect}"
      next if row.empty?

      if bank == :seb
        date = Date.strptime(row["Kuupäev"], "%d.%m.%Y") rescue nil
        description = [row['Saaja/maksja nimi'], row['Selgitus']].compact.join(' ')
        amount = row["Summa"].gsub(",", ".").to_f
        debit_credit = row["Deebet/Kreedit (D/C)"]
      elsif bank == :swedbank
        next if ["K2", "LS", "AS"].include?(row["Tehingu tüüp"])
        date = Date.strptime(row["Kuupäev"], "%d.%m.%Y") rescue nil
        description = [row['Saaja/Maksja'], row['Selgitus']].compact.join(' ')
        amount = row["Summa"].gsub(",", ".").to_f
        debit_credit = row["Deebet/Kreedit"]
      end

      amount *= -1 if debit_credit == "D"

      Cashflow.create!(
        user: current_user,
        date: date,
        description: description,
        amount: amount
      )
    end
  end

end
