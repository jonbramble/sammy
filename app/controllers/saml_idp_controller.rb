class SamlIdpController < SamlIdp::IdpController
  layout 'application'

  def idp_authenticate(email, password)
    user = User.find_by(email: email).try(:authenticate, password)
  end
  private :idp_authenticate

  def idp_make_saml_response(user)
    encode_response(user, encryption: {
      cert: saml_request.service_provider.current_metadata.attributes[:encryption_certificate],
      block_encryption: 'aes256-cbc',
      key_transport: 'rsa-oaep-mgf1p'
    })
  end
  private :idp_make_saml_response

  def idp_logout
    #user = User.find_by(saml_request.name_id)
    #User.last
  end
  private :idp_logout

end