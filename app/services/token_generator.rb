class TokenGenerator

  def initialize(model_name:, token_name:)
    @model_name = model_name
    @token_name = token_name
  end

  def new_token
    begin
      t = SecureRandom.urlsafe_base64
    end while @model_name.class.exists?(@token_name.to_sym => t)
    return t
  end

  def encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def new_encrypted_token
    encrypt(new_token)
  end
  
end