class PostsDatatable
  delegate :params, :h, :link_to, to: :@view
  
  def initialize(view)
    @view = view
  end
  
  def as_json(options = {})
    {
      recordsTotal:  Post.count,
      recordsFiltered: posts.total_entries,
      data: data
    }
  end
  
  private
  
  def data
    posts.map do |post|
      [
        link_to(post.title, post),
        post.content
      ]
    end
  end
  
  def posts
    @posts ||= fetch_posts
  end
  
  def fetch_posts
    posts = Post.order("#{sort_column} #{sort_direction}")
    posts = posts.page(page).per_page(per_page)
    if params[:search].present?
      posts = posts.where("title like :search or content like :search",search: "%#{params[:search][:value]}%")
    end
    posts
  end
  
  def page
    params[:start].to_i/per_page + 1
  end
  
  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end
  
  def sort_column
    columns = %w[title content]
    columns[params[:order]['0'][:column].to_i]
  end
  
  def sort_direction
    params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
  end
end