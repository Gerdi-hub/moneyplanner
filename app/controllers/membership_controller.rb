class MembershipController < ApplicationController
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to group_path, notice: "Membership removed successfully!"
  end
end
