output "hello_app_base_url" {
  description = "Base URL for Hello App API Gateway stage"
  value       = module.api_gw_stage_hello_app.base_url
}

output "movies_app_base_url" {
  description = "Base URL for Movies App API Gateway stage"
  value       = module.api_gw_stage_movies_app.base_url
}
