Factory.define :<%= object_singular %> do |o|
  <% attributes.each do |attribute| %>
    o.<%= attribute.name %> '<%= attribute.default %>'
  <% end %>
end