kong_consumers = ["Contoso", "Kantoso"]

service_setting = {
  retries         = 1
  connect_timeout = 5000
  write_timeout   = 5000
  read_timeout    = 5000
}

kong_upstream_target = ["petstore3.swagger.io:443"]

kong_routes_list = [
  {
    route_name      = "pet_findByStatus2"
    route_protocols = ["http"]
    route_methods   = ["GET"]
    route_hosts     = ["localhost"]
    route_paths     = ["/pet/findByStatus2"]
  },
  {
    route_name      = "pet_findByTags"
    route_protocols = ["http"]
    route_methods   = ["GET"]
    route_hosts     = ["localhost"]
    route_paths     = ["/pet/findByTags"]
  },
  {
    route_name      = "pet"
    route_protocols = ["http"]
    route_methods   = ["GET", "POST", "DELETE", "PUT"]
    route_hosts     = ["localhost"]
    route_paths     = ["/pet"]
  },
  {
    route_name      = "store_inventory"
    route_protocols = ["http"]
    route_methods   = ["GET"]
    route_hosts     = ["localhost"]
    route_paths     = ["/store/inventory"]
  },
  {
    route_name      = "store_order"
    route_protocols = ["http"]
    route_methods   = ["GET", "POST", "DELETE"]
    route_hosts     = ["localhost"]
    route_paths     = ["/store/order"]
  }

]

kong_services_list = [
  {
    service_name     = "pet_findByStatus2"
    service_protocol = "https"
    service_host     = "petstore"
    service_path     = "/api/v3/pet/findByStatus"
    service_port     = "443"
  },
  {
    service_name     = "pet_findByTags"
    service_protocol = "https"
    service_host     = "petstore"
    service_path     = "/api/v3/pet/findByTags"
    service_port     = "443"
  },
  {
    service_name     = "pet"
    service_protocol = "https"
    service_host     = "petstore"
    service_path     = "/api/v3/pet"
    service_port     = "443"
  },
  {
    service_name     = "store_inventory"
    service_protocol = "https"
    service_host     = "petstore"
    service_path     = "/api/v3/store/inventory"
    service_port     = "443"
  },
  {
    service_name     = "store_order"
    service_protocol = "https"
    service_host     = "petstore"
    service_path     = "/api/v3/store/order"
    service_port     = "443"
  }
]