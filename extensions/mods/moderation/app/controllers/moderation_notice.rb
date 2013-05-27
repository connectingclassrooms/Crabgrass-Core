#class YuckyController < ApplicationController
module ModerationNotice
  include ActionView::Helpers::TextHelper # for truncate

  protected

  # Notify the admins that content has been marked as innapropriate
  def send_moderation_notice(flagged)
    return if current_site.dev_email.empty?
    admins = current_site.super_admin_group.users
    admins.each do |admin|
      AdminMailer.deliver_notify_inappropriate admin,
        email_options_for_flagged(flagged)
    end
  end

  def email_options_for_flagged(flagged)
    summary = summary_for_flagged(flagged)
    url = url_for_flagged(flagged)
    mailer_options.merge body: summary,
      url: url,
      owner: current_user,
      subject: I18n.t(:inappropriate_content)
  end

  def summary_for_flagged(flagged)
    flagged.respond_to? :summary ?
      flagged.summary :
      truncate(flagged.body, 400)
  end

  def url_for_flagged(flagged)
    if flagged.is_a? Post
      page = flagged.discussion.page
      page_url(page, only_path: false) + "#posts-#{flagged.id}"
    else
      page_url(flagged)
    end
  end

end

