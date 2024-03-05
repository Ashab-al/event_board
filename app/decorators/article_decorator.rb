class ArticleDecorator < ApplicationDecorator
  delegate_all

  def formatted_create_date
    object.created_at.strftime("%Y-%m-%d")
  end

end
