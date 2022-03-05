output "service_ids_out" {
  value = kong_service.service.*.id
}