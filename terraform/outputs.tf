output "public_url" {
  description = "Public URL for webserver"
  value       = "https://${aws_instance.webserver.public_ip}"
}