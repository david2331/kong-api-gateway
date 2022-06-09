#######################################
# Kong Provider
#######################################
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


#######################################
# Create consumer
#######################################
resource "kong_consumer" "consumer" {
  count    = length(var.kong_consumers)
  username = var.kong_consumers[count.index]
  #     custom_id       = "100"
}


#######################################
# Enable consumer plugin
#######################################
resource "kong_consumer_plugin_config" "consumer_key_auth" {
  count       = length(kong_consumer.consumer)
  consumer_id = kong_consumer.consumer[count.index].id
  plugin_name = "key-auth"
}


#######################################
# Enable global plugin: syslog
#######################################
resource "kong_plugin" "syslog" {

  name        = "syslog"
  enabled     = true
  config_json = <<EOT
    {
        "client_errors_severity": "info",
        "successful_severity": "info",
        "custom_fields_by_lua": null,
        "server_errors_severity": "info",
        "log_level": "debug"
    }
    EOT
}


#######################################
# Enable global plugin: rate limiting
#######################################
resource "kong_plugin" "rate_limit" {

  name        = "rate-limiting"
  enabled     = true
  config_json = <<EOT
    {
        "minute": 5
    }
EOT
}


#######################################
# Enable global plugin: key-auth
# #######################################
resource "kong_plugin" "key-auth" {

  name        = "key-auth"
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
