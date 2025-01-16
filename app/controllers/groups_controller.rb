class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :join, :index]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    if current_user
      Rails.logger.info current_user.inspect  # Logi sisselogitud kasutaja
      @group = current_user.groups.build(group_params)
      if @group.save
        redirect_to @group, notice: 'Group successfully created.'
      else
        Rails.logger.error "Group not saved: #{@group.errors.full_messages}"  # Logib vead
        render :new
      end
    else
      redirect_to new_user_session_path, alert: 'Please sign in to create a group.'
    end
  end

  def show
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to groups_path, alert: 'Group not found!'
    else
      @members = @group.users
      @cashflows = @group.cashflows
    end
  end

  def join
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to groups_path, alert: 'Group not found!'
    else
      membership = @group.memberships.new(user: current_user)
      if membership.save
        redirect_to @group, notice: 'You have successfully joined the group!'
      else
        redirect_to groups_path, alert: 'Unable to join the group.'
      end
    end
  end

  private

  def group_params
    params.require(:group).permit(:name).merge(user_id: current_user.id)
  end
end
