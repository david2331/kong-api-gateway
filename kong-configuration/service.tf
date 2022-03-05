#######################################
# Create single service
#######################################
resource "kong_service" "service" {
  name            = "pet_findByStatus"
  protocol        = "https"
  host            = kong_upstream.petstore.name
  path            = "/api/v3/pet/findByStatus"
  port            = "443"
  retries         = 1
  connect_timeout = 6000
  write_timeout   = 6000
  read_timeout    = 6000
}



#######################################
# Create single route
#######################################
resource "kong_route" "api_route" {
  name      = "pet_findByStatus_route"
  protocols = ["http"]
  methods   = ["GET"]
  hosts     = ["localhost"]
  paths     = ["/pet/findByStatus"]

  strip_path    = true
  preserve_host = false
  #   regex_priority = var.route_regex_priority
  service_id = kong_service.service.id
}



#######################################
# Create multiple service
#######################################
resource "kong_service" "service2" {
  count           = length(var.kong_services_list)
  name            = var.kong_services_list[count.index]["service_name"]
  protocol        = var.kong_services_list[count.index]["service_protocol"]
  host            = var.kong_services_list[count.index]["service_host"]
  path            = var.kong_services_list[count.index]["service_path"]
  port            = var.kong_services_list[count.index]["service_port"]
  retries         = var.service_setting.retries
  connect_timeout = var.service_setting.connect_timeout
  write_timeout   = var.service_setting.write_timeout
  read_timeout    = var.service_setting.read_timeout
}



#######################################
# Create multiple route
#######################################
resource "kong_route" "api_route2" {
  count     = length(var.kong_routes_list)
  name      = var.kong_routes_list[count.index]["route_name"]
  protocols = var.kong_routes_list[count.index]["route_protocols"]
  methods   = var.kong_routes_list[count.index]["route_methods"]
  hosts     = var.kong_routes_list[count.index]["route_hosts"]
  paths     = var.kong_routes_list[count.index]["route_paths"]

  strip_path    = true
  preserve_host = false
  service_id = kong_service.service2[count.index].id
}




