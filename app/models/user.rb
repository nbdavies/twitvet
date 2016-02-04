class User < ActiveRecord::Base
  validate :password_requirements

    def password
      @password ||= BCrypt::Password.new(password_hash)
    end

    def password=(new_password)
      @raw_password = new_password
      @password = BCrypt::Password.create(new_password)
      self.password_hash = @password
    end

    def authenticate(password)
      self.password == password
    end

    def password_requirements
      if @raw_password || new_record? #(id.present?)
        unless @raw_password.length > 5
          errors.add(:password, "must be 6 characters")
        end
      end
    end
end
