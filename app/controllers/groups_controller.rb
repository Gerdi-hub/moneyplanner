class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :join, :index ]

  def index
    @groups = Group.all
  end


  def group_cashflow
    if current_user
      @available_groups = current_user.groups

      if params[:group_id].present?
        @group = Group.find(params[:group_id])

        if @group
          user_ids = @group.memberships.pluck(:user_id)

          @available_months = Cashflow.where(user_id: user_ids)
                                      .pluck(:date)
                                      .map { |d| [ d.strftime("%m-%Y"), d.beginning_of_month ] }
                                      .sort_by { |_, date| date }
                                      .map(&:first)
                                      .uniq
                                      .group_by { |m| m.split("-").last }

          selected_months = params[:months].present? ? params[:months] : @available_months.values.flatten

          @base_cashflows = Cashflow.where(user_id: user_ids)

          if selected_months.present?
            @base_cashflows = @base_cashflows.where(
              "strftime('%m-%Y', date) IN (?)",
              selected_months
            )
          end

          @type_names = @base_cashflows.pluck(:type_name).uniq.compact
          @type_names << "Unspecified" if @base_cashflows.where(type_name: nil).exists?


          @monthly_data = {}
          @type_names.each do |type|
            month_data = selected_months.each_with_object({}) do |month, hash|
              monthly_cashflows = @base_cashflows
                                    .where("strftime('%m-%Y', date) = ?", month)
                                    .where(type_name: type == "Unspecified" ? nil : type)

              hash[month] = monthly_cashflows.sum(:amount)
            end

            @monthly_data[type] = month_data.sort_by { |month, _| Date.strptime(month, "%m-%Y") }.to_h
          end

          @monthly_totals = selected_months.sort_by { |month| Date.strptime(month, "%m-%Y") }.each_with_object({}) do |month, hash|
            monthly_cashflows = @base_cashflows.where("strftime('%m-%Y', date) = ?", month)

            debit_total = monthly_cashflows.where("amount > 0").sum(:amount)
            credit_total = monthly_cashflows.where("amount < 0").sum(:amount)
            difference = debit_total + credit_total

            hash[month] = {
              "Debit Total" => debit_total,
              "Credit Total" => credit_total,
              "Difference" => difference
            }
          end
        else
          redirect_to groups_path, alert: "Group not found!"
        end
      end
    else
      redirect_to new_user_session_path, alert: "Please sign in to view this page."
    end
  end


  def new
    @group = Group.new
  end

  def create
    if current_user
      Rails.logger.info current_user.inspect
      @group = current_user.groups.build(group_params)
      if @group.save
        redirect_to @group, notice: "Group successfully created."
      else
        render :new
      end
    else
      redirect_to new_user_session_path, alert: "Please sign in to create a group."
    end
  end

  def show
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to groups_path, alert: "Group not found!"
    else
      @members = @group.users
      @cashflows = @group.cashflows
    end
  end

  def join
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to groups_path, alert: "Group not found!"
    else
      membership = @group.memberships.new(user: current_user)
      if membership.save
        redirect_to @group, notice: "You have successfully joined the group!"
      else
        redirect_to groups_path, alert: "Unable to join the group."
      end
    end
  end


  private

  def group_params
    params.require(:group).permit(:name).merge(user_id: current_user.id)
  end
end
