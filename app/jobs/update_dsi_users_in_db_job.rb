require 'update_dsi_users_in_db'

class UpdateDsiUsersInDbJob < ApplicationJob
  queue_as :update_dsi_users_in_db

  def perform
    UpdateDsiUsersInDb.new.run!
  end
end
