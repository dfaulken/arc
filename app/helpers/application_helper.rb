module ApplicationHelper
  def title(page_title)
    content_for(:page_title) { 'ARC | ' + page_title }
  end
end
