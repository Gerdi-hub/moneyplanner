class CashflowsController < ApplicationController
  require 'csv' # Ensure the CSV library is loaded
  before_action :authenticate_user!

  def index
    @cashflows = current_user.cashflows.active # Show only active (not soft-deleted) cashflows
  end

  def new
    @cashflow = Cashflow.new
  end

  def create
    @cashflow = current_user.cashflows.build(cashflow_params)

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

    bank = params[:bank]
    file = params[:file]

    Rails.logger.debug "Bank selected: #{bank}"
    if bank == "seb"
      Rails.logger.debug "Processing SEB CSV file"
      process_seb_csv(file)
    elsif bank == "swedbank"
        Rails.logger.debug "Processing SWEDBANK CSV file"
        process_swedbank_csv(file)

    else
      Rails.logger.debug "Unsupported bank format: #{bank}"
      redirect_to root_path, alert: "Unsupported bank format"
    end
  end

  private

  def cashflow_params
    params.require(:cashflow).permit(:amount, :description, :date, :type_name) # Updated method name
  end

  def process_seb_csv(file)
    Rails.logger.debug "Started processing SEB CSV file"
    Rails.logger.debug "File path: #{file.path}"
    Rails.logger.debug "File content preview: #{File.read(file.path).lines.first(5).join}"
    begin
      csv_options = { col_sep: ";", headers: true, encoding: "r:bom|utf-8" }
      CSV.foreach(file.path, "r", **csv_options) do |row|
        next if row.any?(&:nil?) # Skip rows with nil values
        Rails.logger.debug "Processing row: #{row.inspect}"
        if row.empty?
          Rails.logger.debug "Empty row detected, skipping"
          next
        end
        date = Date.strptime(row["Kuupäev"], "%d.%m.%Y") rescue nil
        description = [row['Saaja/maksja nimi'], row['Selgitus']].compact.join(' ')
        amount = row["Summa"].gsub(",", ".").to_f
        debit_credit = row["Deebet/Kreedit (D/C)"]
        amount *= -1 if debit_credit == "D"

        # Save the data to the Cashflow table
        Cashflow.create!(
          user: current_user,
          date: date,
          description: description,
          amount: amount
        )
      end

      redirect_to root_path, notice: "CSV imported successfully"
    rescue => e
      redirect_to root_path, alert: "Error importing CSV: #{e.message}"
    end
  end

  def process_swedbank_csv(file)
    begin
      csv_options = { col_sep: ";", headers: true, encoding: "r:bom|utf-8" }
      CSV.foreach(file.path, "r", **csv_options) do |row|
        next if row.any?(&:nil?) || ["K2", "LS", "AS"].include?(row["Tehingu tüüp"])# Skip rows with nil values
        Rails.logger.debug "Processing row: #{row.inspect}"
        if row.empty?
          Rails.logger.debug "Empty row detected, skipping"
          next
        end
        date = Date.strptime(row["Kuupäev"], "%d.%m.%Y") rescue nil
        description = [row['Saaja/Maksja'], row['Selgitus']].compact.join(' ')
        amount = row["Summa"].gsub(",", ".").to_f
        debit_credit = row["Deebet/Kreedit"]
        amount *= -1 if debit_credit == "D"

        Cashflow.create!(
          user: current_user,
          date: date,
          description: description,
          amount: amount
        )
      end

      redirect_to root_path, notice: "CSV imported successfully"
    rescue => e
      redirect_to root_path, alert: "Error importing CSV: #{e.message}"
    end
  end
end
