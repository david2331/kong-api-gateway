resource "kong_upstream" "petstore" {
  name  = "petstore"
  slots = 1000
  # hash_on              = "header"
  # hash_fallback        = "cookie"
  # hash_on_header       = "HeaderName"
  # hash_fallback_header = "FallbackHeaderName"
  # hash_on_cookie       = "CookieName"
  # hash_on_cookie_path  = "/path"
}


resource "kong_target" "petstore_upstream_target" {
  count       = length(var.kong_upstream_target)
  target      = var.kong_upstream_target[count.index]
  weight      = random_integer.weight.result
  upstream_id = kong_upstream.petstore.id
}

resource "random_integer" "weight" {
  min = 100
  max = 1000 
}