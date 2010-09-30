class <%= controller_name %> < ApplicationController
  
  def index
    @<%= object_plural %> = <%= class_name %>.all
  end
  
  def new
    @<%= object_singular %> = <%= class_name %>.new
  end
  
  def create
    @<%= object_singular %> = <%= class_name %>.new(params[:<%= object_singular %>])
    if @<%= object_singular %>.save
      flash[:message] = "Successfully created <%= object_singular.humanize.downcase %>."
      redirect_to <%= index_url %>
    else
      render :action => 'new'
    end
  end
  
  def show
    @<%= object_singular %> = <%= class_name %>.find(params[:id])
  end
  
  
  def edit
    @<%= object_singular %> = <%= class_name %>.find(params[:id])
    render :action => :new
  end
  
  def update
    @<%= object_singular %> = <%= class_name %>.find(params[:id])
    if @<%= object_singular %>.update_attributes(params[:<%= object_singular %>])
      flash[:message] = "Successfully updated <%= object_singular.humanize.downcase %>."
      redirect_to <%= index_url %>
    else
      render :action => :new
    end
  end
  
  def destroy
    @<%= object_singular %> = <%= class_name %>.find(params[:id])
    begin
      @<%= object_singular %>.destroy
      flash[:message] = "Successfully destroyed <%= object_singular.humanize.downcase %>."
    rescue StandardError => msg
      flash[:warning] = msg.to_s
    end
    redirect_to <%= index_url %>
  end
  
end