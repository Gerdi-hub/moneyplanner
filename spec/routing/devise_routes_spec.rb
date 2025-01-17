require 'rails_helper'

RSpec.describe 'Devise routing', type: :routing do
  describe 'registration routes' do
    it 'routes /users/sign_up to registrations#new' do
      expect(get: '/users/sign_up').to route_to(
                                         controller: 'users/registrations',
                                         action: 'new'
                                       )
    end

    it 'routes POST /users to registrations#create' do
      expect(post: '/users').to route_to(
                                  controller: 'users/registrations',
                                  action: 'create'
                                )
    end

    it 'routes GET /users/edit to registrations#edit' do
      expect(get: '/users/edit').to route_to(
                                      controller: 'users/registrations',
                                      action: 'edit'
                                    )
    end
  end
end
