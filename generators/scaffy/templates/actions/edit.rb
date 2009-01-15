  def edit
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    render :action => :new
  end
