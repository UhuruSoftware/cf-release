module Uhuru::BoshCommander
  class  AppcloudngStatus

    attr_reader :deployment

    def initialize(deployment)
      @deployment = deployment
    end

    #retrieves deployment information
    def status
      state = @deployment.get_state
      current_manifest = nil
      if state == DeploymentState::DEPLOYED
        current_manifest = @deployment.get_manifest()
      else
        current_manifest = load_yaml_file(@deployment.deployment_manifest_path)
      end

      stats = {}

      unless (state == DeploymentState::ERROR) || (state == DeploymentState::NOT_CONFIGURED)
        stats["resources"] = @deployment.get_resources(current_manifest)

        current_manifest["jobs"].each do |job|
          if job["name"] == "router"
            stats["router_ips"] = []
            static_ips = []
            job["networks"].each do |network|
              network["static_ips"].each do |ip|
                static_ips << ip
              end
            end
            stats["router_ips"] << static_ips
          end
        end
      end

      properties = current_manifest["properties"]
      stats["name"] = @deployment.deployment_name
      stats["state"] = state
      stats["api_url"] = properties["cc"]["srv_api_uri"]
      stats["uaa_url"] = properties["uaa_endpoint"]
      stats["web_ui_url"] = "www.#{properties["domain"]}"
      stats["admin_email"] = properties["uaa"]["scim"]["users"][0].split('|')[0] 
      stats["app_domains"] = properties["app_domains"]
      stats["sys_org"] = properties["system_domain_organization"]
      #stats["contact_email"] = "CHANGEME"
      stats["support_url"] = properties["support_address"]


      current_manifest["jobs"].each do |job|
        if (job['name'].to_s.end_with?('_node_free') && job['instances'] > 0)
          service_name = job['name'].split('_')[0]
          if service_name == "rabbit"
            stats["#{service_name}_service_token"] = "cf -f  create-service-auth-token  --label #{service_name}mq  --provider core  --token #{properties["#{service_name}_gateway"]["token"]}"
          else
            stats["#{service_name}_service_token"] = "cf -f  create-service-auth-token  --label #{service_name}  --provider core  --token #{properties["#{service_name}_gateway"]["token"]}"
          end

        end
      end
      #stats["mysql_service_token"] ="cf -f  create-service-auth-token  --label mysql  --provider core  --token #{properties["mysql_gateway"]["token"]}"
      #stats["mongodb_service_token"] ="cf -f  create-service-auth-token  --label mongodb  --provider core  --token #{properties["mongodb_gateway"]["token"]}"
      #stats["memcached_service_token"] ="cf -f  create-service-auth-token  --label memcached  --provider core  --token #{properties["memcached_gateway"]["token"]}"
      #stats["vblob_service_token"] ="cf -f  create-service-auth-token  --label vblob  --provider core  --token #{properties["vblob_gateway"]["token"]}"
      #stats["elasticsearch_service_token"] ="cf -f  create-service-auth-token  --label elasticsearch  --provider core  --token #{properties["elasticsearch_gateway"]["token"]}"
      #stats["postgresql_service_token"] ="cf -f  create-service-auth-token  --label postgresql  --provider core  --token #{properties["postgresql_gateway"]["token"]}"
      #stats["redis_service_token"] ="cf -f  create-service-auth-token  --label redis  --provider core  --token #{properties["redis_gateway"]["token"]}"
      #stats["rabbit_service_token"] ="cf -f  create-service-auth-token  --label rabbit  --provider core  --token #{properties["rabbit_gateway"]["token"]}"

      #stats["services"] = ["mysql_node", "mssql_node", "uhurufs_node", "rabbit_node", "postgresql_node", "redis_node", "mongodb_node"].map { |node|
      #  current_manifest["jobs"] != nil && current_manifest["jobs"].select{|job| job["name"] == node}.first["instances"] > 0 ? node : nil }.compact
      stats["stacks"] = ["dea_next", "win_dea"].map { |stack|
        current_manifest["jobs"] != nil && current_manifest["jobs"].select{|job| job["name"] == stack}.first["instances"] > 0 ? stack : nil }.compact
      if current_manifest["release"]
        stats["version"] = current_manifest["release"]["version"]
      else
        stats["version"] = current_manifest["releases"][0]["version"]
      end
      stats
    end
  end
end
