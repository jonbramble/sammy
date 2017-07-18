namespace :metadata do
  desc "TODO"
  task persist: :environment do
    identifier = "http://localhost:3001"
    metadata_url = "http://localhost:3001/users/saml/metadata"
    puts "Fetching data for #{identifier} from #{metadata_url}"
    metadata = Net::HTTP.get(URI.parse(metadata_url))
    ap metadata
    settings = SamlIdp::IncomingMetadata.new(metadata)
    ap settings.to_h
    cert = OpenSSL::X509::Certificate.new("-----BEGIN CERTIFICATE-----\n"+settings.signing_certificate+"\n-----END CERTIFICATE-----\n")
    puts cert
    puts "SHA1 FingerPrint: " + OpenSSL::Digest::SHA1.new(cert.to_der).to_s.scan(/../).join(':').upcase
    fname = identifier.to_s.gsub(/\/|:/,"_")
    `mkdir -p #{Rails.root.join("cache/saml/metadata")}`
    File.open Rails.root.join("cache/saml/metadata/#{fname}"), "r+b" do |f|
      Marshal.dump settings.to_h, f
    end
  end
  task keys: :environment do
   opts = {
    common_name: "sammy.idp", 
    country: "CA",                	
    state: "BC",            		
    org: "PharmSci",                 	
    org_unit: "BioPhysics",             
    email: "webmaster@galenus.pharmsci.ubc.ca",
    expire_in_days: 5*365
   }
	ssl = Fauthentic.generate(opts)		#generate the keys
	cert_string = ssl.cert.to_pem
	key_string = ssl.key.to_s
        secrets = { 'shared' => {'cert' => cert_string, 'private_key' => key_string}}
   	File.open(Rails.root.join('config/saml_secrets.yml'), "w"){|f| f.write secrets.to_yaml}
	
  end
end
