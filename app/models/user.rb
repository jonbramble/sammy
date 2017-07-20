class User < ApplicationRecord
 has_secure_password

 def asserted_attributes
       {
         uid: { 
           getter: :uid,
           #name: "urn:mace:dir:attribute-def:uid",
           name: "urn:oid:0.9.2342.19200300.100.1.1",
           name_id_format: Saml::XML::Namespaces::Formats::NameId::TRANSIENT
         },
         email: { 
           getter: :email, 
           #name: "urn:mace:dir:attribute-def:mail",
	   name: "urn:oid:0.9.2342.19200300.100.1.3",
           name_format: Saml::XML::Namespaces::Formats::Attr::URI
         },
         sn: {
           getter: :lname,
           #name: "urn:mace:dir:attribute-def:sn",
           name: "urn:oid:2.5.4.4",
           name_format: Saml::XML::Namespaces::Formats::Attr::URI
         
         },
         givenName: {
           getter: :fname,
           #name: "urn:mace:dir:attribute-def:givenName",
           name: "urn:oid:2.5.4.42",
           name_format: Saml::XML::Namespaces::Formats::Attr::URI
         }
       }
 end
 
end
