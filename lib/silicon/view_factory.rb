require 'silicon/template_registry'
require 'silicon/view_builders/json'
require 'silicon/view_builder_registry'

module Silicon
  class ViewFactory
    def initialize(container, template_registry, view_builder_registry)
      @container = container
      @template_registry = template_registry
      @view_builder_registry = view_builder_registry
    end

    def create(name, content_type)
      type = content_type.split('/')[1]
      template = @template_registry.get(name, type)
      builder = @view_builder_registry.get(type)
      view = builder.new(template, @container)
      view.process
    end
  end
end