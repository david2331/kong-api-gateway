terraform {
  required_providers {
    kong = {
      source  = "greut/kong"
      version = "5.3.0"
    }
  }
}

provider "kong" {
  kong_admin_uri = "http://localhost:8001"
}


resource "kong_consumer" "consumer" {
  # count    = var.kong_consumer != "" ? 1 : 0
  username = "Contoso"
  #     custom_id       = "100"
}




resource "kong_service" "service" {
  count           = var.enable == "true" ? length(var.kong-services-list) : 0
  name            = var.kong-services-list[count.index]["service_name"]
  protocol        = var.kong-services-list[count.index]["service_protocol"]
  host            = var.kong-services-list[count.index]["service_host"]
  path            = var.kong-services-list[count.index]["service_path"]
  port            = var.kong_service_port
  retries         = var.service_retries
  connect_timeout = var.connect_timeout
  write_timeout   = var.write_timeout
  read_timeout    = var.read_timeout
}

resource "kong_route" "api_route" {
  count     = var.enable == "true" ? length(var.kong-services-list) : 0
  name      = var.kong-services-list[count.index]["route_name"]
  protocols = var.kong-services-list[count.index]["route_protocols"]
  methods   = var.kong-services-list[count.index]["route_methods"]
  hosts     = var.kong-services-list[count.index]["route_hosts"]
  paths     = var.kong-services-list[count.index]["route_paths"]

  strip_path     = var.route_strip_path
  preserve_host  = var.route_preserve_host
  regex_priority = var.route_regex_priority
  service_id     = kong_service.service[count.index].id
}




resource "kong_consumer_plugin_config" "consumer_acl_config" {

  count       = var.kong_consumer != "" ? 1 : 0
  consumer_id = kong_consumer.consumer[count.index].id
  plugin_name = "acls"

  config_json = <<EOT
    {
        "group": "${var.kong_acl}"
    }
    EOT
}


resource "kong_consumer_plugin_config" "consumer_key_auth_config" {
  count       = var.kong_consumer != "" ? 1 : 0
  consumer_id = kong_consumer.consumer[count.index].id
  plugin_name = "key-auth"
}



resource "kong_plugin" "key-auth" {

  count       = var.enable == "true" ? length(var.kong-services-list) : 0
  name        = "key-auth"
  route_id    = kong_route.api_route[count.index].id
  config_json = <<EOT
    {
        "key_names": [
              "x-api-key"
        ],
        "run_on_preflight": true,
        "anonymous": null,
        "hide_credentials": false,
        "key_in_body": false
    }
    EOT
}



resource "kong_plugin" "acl" {

  # count         = var.kong_acl != "" ? 1: 0
  count       = var.enable == "true" ? length(var.kong-services-list) : 0
  route_id    = kong_route.api_route[count.index].id
  name        = "acl"
  config_json = <<EOT
    {
         "allow": ["${var.kong_acl}"],
      "hide_groups_header": false,
      "deny": null
    }
    EOT
}


resource "kong_plugin" "rate_limit" {

  count       = var.enable == "true" ? length(var.kong-services-list) : 0
  name        = "rate-limiting"
  enabled     = true
  route_id    = kong_route.api_route[count.index].id
  config_json = <<EOT
    {
        "second": 50,
        "hour" : 4000
    }
EOT
}




resource "kong_plugin" "route_cors" {

  count       = var.enable == "true" ? length(var.kong-services-list) : 0
  name        = "cors"
  enabled     = true
  route_id    = kong_route.api_route[count.index].id
  config_json = <<EOT
    {
        "headers": [
      "Accept-Version",
      "X-Auth-Token",
      "Date",
      "Content-Type",
      "Content-Length",
      "Content-MD5",
      "Origin",
      "Access-Control-Allow-Origin"
    ],
    "origins": [
      "http://localhost"
    ]
    }
EOT
}



resource "kong_plugin" "ip_restriction" {

  count       = var.enable == "true" && length(var.ip_whitelist) > 0 ? 1 : 0
  name        = "ip-restriction"
  enabled     = true
  consumer_id = kong_consumer.consumer[count.index].id
  config_json = <<EOT
  {
    "allow": ${jsonencode(var.ip_whitelist)}
  }
EOT

}




# module "kong-services" {
#   source                 = "mattyait/module/kong"
#   version                = "0.1.0"
#   kong-api-create-enable = "true"
#   kong_admin_uri         = "http://localhost:8001/"

#   kong-services-list = [
#     {
#       service_name     = "findByStatus"
#       service_protocol = "https"
#       service_host     = "petstore.swagger.io"
#       service_path     = "/"

#       route_name      = "findByStatus-route"
#       route_protocols = ["http", "https"]
#       route_methods   = ["GET"]
#       route_hosts     = ["localhost:8000"]
#       route_paths     = ["/pet/findByStatus"]
#     },
#   ]
# }