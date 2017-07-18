SamlIdp.configure do |config|

  base = Rails.application.secrets.base

  config.x509_certificate = Rails.application.secrets.x509_certificate
  config.secret_key = Rails.application.secrets.secret_key
  config.password = "testpass" #where is this used?
  config.algorithm = :sha256
  config.organization_name = Rails.application.secrets.organization_name
  config.organization_url = Rails.application.secrets.base
  config.base_saml_location = "#{base}/saml"
  # config.reference_id_generator # Default: -> { UUID.generate }
  config.attribute_service_location = "#{base}/saml/attributes"
  config.single_service_post_location = "#{base}/saml/auth"

  config.name_id.formats =
  {    
       uid: -> (principal) {principal.uid },
       transient: -> (principal) { principal.id },
       persistent: -> (p) { p.id },
  }

  #> OpenSSL::Digest::SHA1.new(cert.to_der).to_s.scan(/../).join(':').upcase
  #$ openssl x509 -in test2.crt -noout -sha256 -fingerprint
  service_providers = {
    "http://localhost:3001" => {
      #fingerprint: "4C:CD:3B:0B:26:48:A9:91:A8:6A:8E:D7:90:A8:3A:47:0F:0E:C4:80", #daisy
      fingerprint: "4C:56:82:76:C3:8A:2E:43:EA:2C:5A:C9:FD:5D:DA:DC:79:9E:1C:55",
      metadata_url: "http://localhost:3001/users/saml/metadata"
    },
  }

  # `identifier` is the entity_id or issuer of the Service Provider,
  # settings is an IncomingMetadata object which has a to_h method that needs to be persisted
  config.service_provider.metadata_persister = ->(identifier, settings) {
    fname = identifier.to_s.gsub(/\/|:/,"_")
    `mkdir -p #{Rails.root.join("cache/saml/metadata")}`
    File.open Rails.root.join("cache/saml/metadata/#{fname}"), "r+b" do |f|
      Marshal.dump settings.to_h, f
    end
  }

  # `identifier` is the entity_id or issuer of the Service Provider,
  # `service_provider` is a ServiceProvider object. Based on the `identifier` or the
  # `service_provider` you should return the settings.to_h from above
  config.service_provider.persisted_metadata_getter = ->(identifier, service_provider){
    fname = identifier.to_s.gsub(/\/|:/,"_")
    `mkdir -p #{Rails.root.join("cache/saml/metadata")}`
    full_filename = Rails.root.join("cache/saml/metadata/#{fname}")
    if File.file?(full_filename)
      File.open full_filename, "rb" do |f|
        Marshal.load f
      end
    end
  }

  # Find ServiceProvider metadata_url and fingerprint based on our settings
  config.service_provider.finder = ->(issuer_or_entity_id) do
    service_providers[issuer_or_entity_id]
  end

end
