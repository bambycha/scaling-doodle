Datadog.configure do |c|
  c.env = 'development'
  c.use :rails, service_name: 'shopping_cart'
  c.analytics_enabled = true
  c.runtime_metrics_enabled = true
end
