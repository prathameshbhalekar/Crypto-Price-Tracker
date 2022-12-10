class Alert < ApplicationRecord
    belongs_to :user

    validates :trigger, presence: true, numericality: true
    validates :init_price, presence: { message: "Symbol not found" }, numericality: true
    validates :symbol, presence: true
    

    after_initialize do |alert|
        if alert.init_price.nil?
            alert.init_price = getCurrentPrice(alert.symbol || "")
        end
    end

    def getCurrentPrice(symbol)
        Rails.cache.fetch("currency_price/#{symbol}", :expires_in => 1.minutes) do
            options = { query: { 
                order: "market_cap_desc", 
                per_page: 1, 
                page: 1,
                sparkline: false, 
                vs_currency: "USD",
                ids: symbol 
                }
            }
        
            res = HTTParty.get("https://api.coingecko.com/api/v3/coins/markets", options)
            body = JSON.parse(res.body)
            (body[0] || {})['current_price'] || nil

        end
    
    end
end
