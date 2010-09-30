class Create<%= human_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= object_plural %> do |t|
    <%- for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
      t.timestamps
    end
  end
  
  def self.down
    drop_table :<%= object_plural %>
  end
end
