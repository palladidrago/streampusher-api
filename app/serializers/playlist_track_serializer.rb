class PlaylistTrackSerializer < ActiveModel::Serializer
  attributes :audio_file_name, :podcast_published_date, :id,
    :track_id, :playlist_id, :title, :display_name, :position, :updated_at,
    :cdn_url, :labels, :scheduled_show_id
  has_many :labels, embed: :ids, key: :labels, embed_in_root: true

  def scheduled_show_id
    object.track.scheduled_show_id
  end

  def display_name
    object.track.display_name
  end

  def audio_file_name
    object.track.audio_file_name
  end

  def cdn_url
    object.track.cdn_url
  end

  def title
    object.track.display_name
  end

  def labels
    object.track.labels
  end
end
