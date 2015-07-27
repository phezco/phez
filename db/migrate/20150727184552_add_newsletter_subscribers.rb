class AddNewsletterSubscribers < ActiveRecord::Migration
  def change
    # Remove devise confirmable attributes:
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email

    add_column :users, :is_newsletter_subscribed, :boolean, default: false
    User.update_all(is_newsletter_subscribed: false)

    add_column :users, :secret, :string, unique: true
    add_column :users, :is_confirmed, :boolean, default: false
    User.update_all(is_confirmed: false)

    create_table :newsletter_subscribers do |t|
      t.string :email
      t.boolean :is_confirmed, default: false
      t.string :secret, unique: true
      t.timestamps null: false
    end
  end
end
