class SubphezSerializer < ActiveModel::Serializer
  attributes :path, :title, :url, :creator, :subscriber_count, :sidebar, :created_at

  def creator
    object.user.username
  end

  def sidebar
    object.sidebar_rendered
  end

end