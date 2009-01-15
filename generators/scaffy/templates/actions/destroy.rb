  def destroy
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    begin
      @<%= singular_name %>.destroy
      flash[:message] = "Successfully destroyed <%= name.humanize.downcase %>."
    rescue ApplicationError => msg
      flash[:warning] = msg.to_s
    end
    redirect_to <%= plural_name %>_url
  end
