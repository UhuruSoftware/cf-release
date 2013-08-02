module Uhuru::BoshCommander
  class AppcloudUpgrade
    def self.upgrade(old_manifest, new_manifest)

      new_manifest["jobs"].each do |job|
        old_job = old_manifest["jobs"].select{|j| j["name"] == job["name"]}.first
        if old_job
          if job["networks"][0].has_key?("static_ips")
            job["networks"][0]["static_ips"] = old_job["networks"][0]["static_ips"]
          end
        end
      end

      keys = YAML.load_file File.join(File.expand_path("../../config/upgrade_keys.yml", __FILE__))
      keys["keys"].each do |key, value|

        begin
          new_key = eval('new_manifest' + key)
          if new_key
            old_key = eval('old_manifest' + value)
            if old_key
              eval('new_manifest' + key +'=old_manifest' + value)
            end
          end
        rescue
          $logger.warn "Could not import old value #{value} into new #{key}"
        end
      end

      new_manifest
    end
  end
end
