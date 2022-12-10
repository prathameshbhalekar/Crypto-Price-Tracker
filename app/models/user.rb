class User < ApplicationRecord
    has_many :alerts

    has_secure_password
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 

    PASSWORD_REQUIREMENTS = / \A
        (?=.*\d) #Contain atleast one number
    /x

    validates :password,
                length: { minimum: 6 },
                if: -> { new_record? || !password.nil? },
                format: { with: PASSWORD_REQUIREMENTS}


    def getAllAlerts(is_active, symbol)
        Rails.cache.fetch("alerts/#{self.username}/#{symbol}-#{is_active}", :expires_in => 5.minutes) do

            alerts = Alert.where(user: self)
        
            if !is_active.eql? "all"
                alerts = alerts.where(is_active: is_active)
            end

            if !symbol.eql? "all"
                alerts = alerts.where(symbol: symbol)
            end
            alerts
        end
    end
end
