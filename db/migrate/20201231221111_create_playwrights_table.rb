class CreatePlaywrightsTable < ActiveRecord::Migration
  def change
    create_table :playwrights do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :bio
    end
  end
end
