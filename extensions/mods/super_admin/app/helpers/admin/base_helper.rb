module Admin::BaseHelper
  def flash_notice
    "<div class='errorExplanation'>#{flash[:notice]}</div>" if flash[:notice]
  end

  def alphabetical_filter url_options
    links = []
    (('A'..'Z').to_a+['#']).each do |letter|
      links << link_to(letter, url_options.merge(:letter => letter),
                       :class => "alphabetical_filter_letter #{'inverted' if @letter == letter}")
    end
    links << link_to("ALL", url_options, :class => "alphabetical_filter_letter #{'inverted' if @letter.empty?}")
    content_tag(:span, safe_join(links, '&nbsp;'.html_safe), :class => 'alphabetical_filter')
  end
end

