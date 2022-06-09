# kong-api-gateway
Deploying kong, konga using docker-compose and terraform



docker-compose up -d

docker-compose scale kong=5

docker restart nginx

http :8001 | jq [.hostname]


admin: http://localhost:8001


http :8000/pet/findByStatus?status=available x-api-key:[customer-api-key]





Download the current kong configuration file
===========================================
deck dump --kong-addr http://localhost:8001

Check the diff before update the kong server
===========================================
deck diff --kong-addr http://localhost:8001

Upload the current kong configuration file
===========================================
deck sync --kong-addr http://localhost:8001
