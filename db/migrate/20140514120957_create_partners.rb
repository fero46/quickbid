class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :fullname
      t.string :firma
      t.text  :adresse
      t.string :telefon
      t.string :email
      t.text :notiz
      t.string :kontoinhaber
      t.string :bank
      t.string :iban
      t.string :bic
      t.string :refcode
      t.string :partner_code
      t.timestamps
    end
    add_index :partners, :refcode, unique: true
  end
end
