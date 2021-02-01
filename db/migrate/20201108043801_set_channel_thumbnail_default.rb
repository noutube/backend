class SetChannelThumbnailDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :channels, :thumbnail, from: nil, to: ''
  end
end
