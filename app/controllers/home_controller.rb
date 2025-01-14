class HomeController < ApplicationController
  def index
    if current_user.present?
      @current_user = current_user
      @user_cashflows = current_user.cashflows.active

      @available_years = @user_cashflows.distinct.pluck(Arel.sql("strftime('%Y', date)")).sort.reverse
      @available_months = @user_cashflows.distinct.pluck(Arel.sql("strftime('%m-%Y', date)")).sort.reverse.map { |month| Date.strptime(month, "%m-%Y") }



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


      @monthly_data = @cashflows.group_by do |cashflow|
        cashflow.date.strftime("%m-%Y")
      end.transform_values do |cashflows|
        # Group by type and calculate sums
        types_data = cashflows.group_by(&:type_name).transform_values do |grouped_cashflows|
          grouped_cashflows.sum(&:amount)
        end


        debit_total = cashflows.select { |c| c.amount > 0 }.sum(&:amount)
        credit_total = cashflows.select { |c| c.amount < 0 }.sum(&:amount)
        difference = credit_total + debit_total


        types_data.merge({
                           "Debit Total" => debit_total.abs,
                           "Credit Total" => credit_total,
                           "Difference" => difference
                         })
      end


      @row_labels = @monthly_data.values.flat_map(&:keys).uniq.reject { |label| ["Debit Total", "Credit Total", "Difference"].include?(label) }
    end

  end
end
