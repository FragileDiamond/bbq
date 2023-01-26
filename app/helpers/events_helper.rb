# frozen_string_literal: true

module EventsHelper
  def current_user_can_subscribe?(event)
    if current_user == event.user || event.subscribers.include?(current_user)
      false
    else
      true
    end
  end
end
