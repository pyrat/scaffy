  def index
    @<%= index_name %> = <%= class_name %>.find(:all)
  end
