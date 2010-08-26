class CreateReferrers < ActiveRecord::Migration
  def self.up
    create_table :referrers do |t|
      t.integer :applicant_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :reference_text

      t.timestamps
    end
  end

  def self.down
    drop_table :referrers
  end
end
