output "hello_app_base_url" {
  description = "Base URL for Hello App API Gateway stage"
  value       = var.deploy_hello_app ? module.hello_app[0].base_url : null
}

output "movies_app_base_url" {
  description = "Base URL for Movies App API Gateway stage"
  value       = var.deploy_movies_app ? module.movies_app[0].base_url : null
}

output "secret_app_base_url" {
  description = "Base URL for Secret App API Gateway stage"
  value       = var.deploy_secret_app ? module.secret_app[0].base_url : null
}
