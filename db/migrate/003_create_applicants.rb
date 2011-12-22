class CreateApplicants < ActiveRecord::Migration
  # TODO look to see if some fields are better set as integer types (phone number, area codes, etc.)
  def self.up
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :email
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :phone
      t.string :website
      t.string :blog
      t.string :social_networks

      t.timestamps
    end
  end

  def self.down
    drop_table :applicants
  end
end
