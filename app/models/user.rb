require 'pry'

class User < ActiveRecord::Base
  has_many :favorites
  has_many :events, through: :favorites

  def get_all_favorites
    Favorite.all.select do |fave|
      self.id === fave.user_id
    end
  end

  def get_all_event
    get_all_favorites.map do |fave|
      Event.all.find_by_id(fave.event_id)
    end
  end
end
