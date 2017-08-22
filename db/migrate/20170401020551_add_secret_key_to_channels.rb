class AddSecretKeyToChannels < ActiveRecord::Migration[4.2]
  def change
    add_column :channels, :secret_key, :string, default: '', null: false
    Channel.all.each do |channel|
      channel.generate_secret_key
      channel.save
    end
  end
end
