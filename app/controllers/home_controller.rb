class HomeController < ApplicationController
  def index
    # Get all available years from cashflow records
    @available_years = Cashflow.distinct.pluck(Arel.sql("strftime('%Y', date)")).sort.reverse

    # If years are selected, filter the data
    if params[:years].present?
      @selected_years = params[:years]
      @cashflows = Cashflow.where(Arel.sql("strftime('%Y', date) IN (?)"), @selected_years)
    else
      @selected_years = []
      @cashflows = Cashflow.all
    end

    # Group the cashflows by month
    @monthly_data = @cashflows.group_by do |cashflow|
      cashflow.date.strftime("%Y-%m")
    end.transform_values do |cashflows|
      # Group by type and calculate sums
      types_data = cashflows.group_by(&:type_name).transform_values do |grouped_cashflows|
        grouped_cashflows.sum(&:amount)
      end

      # Calculate totals
      debit_total = cashflows.select { |c| c.amount < 0 }.sum(&:amount)
      credit_total = cashflows.select { |c| c.amount > 0 }.sum(&:amount)
      difference = credit_total + debit_total

      # Add totals to the hash
      types_data.merge({
                         "Debit Total" => debit_total.abs,
                         "Credit Total" => credit_total.abs,
                         "Difference" => difference
                       })
    end

    # Collect labels for rows (only include those with actual data)
    @row_labels = @monthly_data.values.flat_map(&:keys).uniq
  end
  end