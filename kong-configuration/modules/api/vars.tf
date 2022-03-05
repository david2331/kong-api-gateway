variable enable {
  default = "true"
}

variable service_retries {
  default = "5"
}

variable connect_timeout {
  default = "60000"
}

variable write_timeout {
  default = "60000"
}

variable read_timeout {
  default = "60000"
}

variable route_strip_path {
  type    = bool
  default = true
}

variable route_preserve_host {
  type    = bool
  default = true
}

variable route_regex_priority {
  default = "0"
}

variable kong_service_port {
  default = "80"
}

variable "kong-services-list" {
  description = "List of services want to create"
  type        = list
  default     = []
}



######################### Custom Variable ##################
variable kong_consumer {
  type    = string
  default = ""
}

variable kong_acl {
  type    = string
  default = ""
}


variable ip_whitelist {
  type    = list
  default = []
}