  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      flash[:message] = "Successfully updated <%= singular_name.humanize.downcase %>."
      redirect_to <%= index_name %>_url
    else
      render :action => :new
    end
  end
