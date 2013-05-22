module UserExtension::Sorting
  extend ActiveSupport::Concern

  included do
    scope :active_since, lambda{ |since|
      where(["users.last_seen_at > ?", since]).
        order('users.last_seen_at DESC')
    }

    scope :inactive_since, lambda{ |since|
      where(["users.last_seen_at < ? OR users.last_seen_at IS NULL", since]).
        order('users.last_seen_at ASC')
    }

  end

  def initial
    login.chars.first.upcase
  end

end
