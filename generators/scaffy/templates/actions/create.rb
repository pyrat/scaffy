  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save
      flash[:message] = "Successfully created <%= name.humanize.downcase %>."
      redirect_to <%= index_name %>_url
    else
      render :action => 'new'
    end
  end
