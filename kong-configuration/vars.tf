
variable "kong_services_list" {
  type = list(object({
    service_name     = string
    service_protocol = string
    service_host     = string
    service_path     = string
    service_port     = string
  }))
  #   default = [
  #     {
  #       service_name     = "pet_findByStatus2"
  #       service_protocol = "https"
  #       service_host     = "petstore"
  #       service_path     = "/api/v3/pet/findByStatus"
  #       service_port     = "443"
  #     }
  #   ]
}




variable "kong_routes_list" {
  type = list(object({
    route_name      = string
    route_protocols = list(string)
    route_methods   = list(string)
    route_hosts     = list(string)
    route_paths     = list(string)

  }))
  #   default = [
  #     {
  #       route_name      = "pet_findByStatus2"
  #       route_protocols = ["http"]
  #       route_methods   = ["GET"]
  #       route_hosts     = ["localhost"]
  #       route_paths     = ["/pet/findByStatus2"]
  #     }
  #   ]
}





variable "service_setting" {
  type = object({
    retries         = number
    connect_timeout = number
    write_timeout   = number
    read_timeout    = number
  })
}


variable "kong_consumers" {
  type = list(string)
}

variable "kong_upstream_target" {
  type = list(string)
}
