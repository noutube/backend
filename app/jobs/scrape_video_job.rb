class ScrapeVideoJob < ApplicationJob
  queue_as :default

  def perform(*video)
    return if video.duration
    video.scrape
    video.save
  end
end
