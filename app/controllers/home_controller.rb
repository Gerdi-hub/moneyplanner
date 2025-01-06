class HomeController < ApplicationController
  def index
    # Fetch all cashflows
    @cashflows = Cashflow.all

    # Group by month (YYYY-MM format) and type_name
    @monthly_data = @cashflows.group_by do |cashflow|
      cashflow.date.beginning_of_month.strftime('%Y-%m') # Group by month
    end.transform_values do |cashflows|
      type_data = cashflows.group_by(&:type_name).transform_values { |group| group.sum(&:amount) }
      debit_total = cashflows.select { |cf| cf.amount < 0 }.sum(&:amount).abs
      credit_total = cashflows.select { |cf| cf.amount > 0 }.sum(&:amount)
      difference = credit_total - debit_total

      type_data.merge(
        'Debit Total' => debit_total,
        'Credit Total' => credit_total,
        'Difference' => difference
      )
    end

    # Collect all unique type_names including totals for row labels
    @row_labels = @monthly_data.values.flat_map(&:keys).uniq
  end
end