require "inflection"

module TestHelpers
  module JsonApi
    def data
      body.fetch("data")
    end

    def included
      body.fetch("included")
    end

    def links
      body.fetch("links")
    end

    def resource(name)
      resources(plural(name)).fetch(0)
    end

    def resources(name)
      Array(data).select { |hash| hash["type"] == name }
    end

    def associated_resources(name, linked_name)
      associations(name, linked_name).map do |link|
        included_resource(link["type"], link["id"])
      end
    end

    def associated_resource(name, linked_name)
      associated_resources(name, linked_name).fetch(0)
    end

    def association(name, association_name)
      associations(name, association_name).fetch(0)
    end

    def associations(name, association_name)
      Array resource_links(name).fetch(association_name).fetch("linkage")
    end

    def included_resource(type, id)
      included_resources(type).select { |hash| hash["id"] == id }.fetch(0)
    end

    def included_resources(type)
      included.select { |hash| hash["type"] == type }
    end

    def resource_links(name)
      resource(name).fetch("links")
    end

    def error
      errors.fetch(0)
    end

    def errors
      body.fetch("errors")
    end

    private

    def plural(string)
      Inflection.plural(string)
    end

    def Array(object)
      if Hash === object
        [object]
      else
        super
      end
    end
  end
end