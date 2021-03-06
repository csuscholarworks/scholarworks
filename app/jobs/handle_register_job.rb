class HandleRegisterJob < Hyrax::ApplicationJob
  include Rails.application.routes.url_helpers
  def perform(resource)
    return true if resource.handle.present?

    path = polymorphic_url(resource, host: ENV['SCHOLARWORKS_HOST'])
    HandleService.register(resource, path)
  end
end
