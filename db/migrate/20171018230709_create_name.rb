class CreateName < ActiveRecord::Migration[5.1]
  def change
    create_table :partners do |t|
         t.string :name
         t.integer :phone_number
         t.string :industry
         t.string :problem
         t.string :customer
       end
  end
end
