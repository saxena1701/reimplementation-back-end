class AddAuthorizationToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :authorization, :string
  end
end
