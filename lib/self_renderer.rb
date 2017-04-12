require "json"
require "active_support/core_ext/string/inflections"
require "self_renderer/version"

module SelfRenderer
  # Renders an HTML string reprsenting this object
  def render_to_html(template: nil, partial: nil, assigns: {}, locals: {})
    return render_self template: "#{template}.html", assigns: assigns, locals: locals if template.present?
    render_self partial: "#{partial}.html", assigns: assigns, locals: locals
  end

  # Renders a JSON string reprsenting this object
  def render_to_json(template: nil, partial: nil, assigns: {}, locals: {})
    return render_self template: "#{template}.json", assigns: assigns, locals: locals if template.present?
    render_self partial: "#{partial}.json", assigns: assigns, locals: locals
  end

  # Returns a Hash representation of this object as rendered by #render_to_json
  def render_to_hash(template: nil, partial: nil, assigns: {}, locals: {})
    JSON.load render_to_json(template: template, partial: partial, assigns: assigns, locals: locals)
  end

  protected

    def self_renderer
      @self_renderer ||= begin
        renderer = ApplicationController.renderer.new

        # HACK: get around limitations in devise/warden when rendering
        #       views outside the contect of a formal http request
        if defined? Warden
          env = renderer.instance_eval { @env }
          warden = Warden::Proxy.new(env, Warden::Manager.new(Rails.application))
          env["warden"] = warden
        end

        renderer
      end
    end

    def render_self(template: nil, partial: nil, assigns: {}, locals: {})
      name = self.class.name.parameterize(separator: "_")
      assigns[name] = self
      locals[name] = self
      return self_renderer.render(template, assigns: assigns, locals: locals).squish if template
      return self_renderer.render(partial: partial, assigns: assigns, locals: locals).squish if partial
      nil
    end
end