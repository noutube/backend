module Auth
  JWT_SECRET = ENV['JWT_SECRET']
  JWT_ALGORITHM = 'HS256'

  class << self
    def decode(token)
      decoded_token = JWT.decode(token, JWT_SECRET, true, { algorith: JWT_ALGORITHM })
      decoded_token[0]
    end

    def encode(payload)
      JWT.encode(payload, JWT_SECRET, JWT_ALGORITHM)
    end
  end
end
