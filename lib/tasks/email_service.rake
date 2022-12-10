require 'bunny'

namespace :email_service do
    desc 'Process alerts from queue messages'
    task :start => [:environment] do
        connection = Bunny.new(hostname: ENV["RABBITMQ_HOST"])
        connection.start

        channel = connection.create_channel
        queue = channel.queue('BINANCE_MESSAGES')
        Rails.logger.info('Started Email Service')

        begin
            queue.subscribe(manual_ack: true, block: true) do |_delivery_info, _properties, body|
                parsed = JSON.parse(body)
                price =  parsed['p'].to_f
                
                triggered_alerts = Alert
                .includes(:user)
                .where([
                    "(:price >= trigger and init_price < trigger) or (:price <= trigger and init_price > trigger)", 
                    { price: price}
                ])
                .where(is_active: true)
                
                
                triggered_alerts.each do |alert| 
                    AlertMailer.with(alert: alert, price: price).trigger_email.deliver_now
                end

                triggered_alerts.update_all(is_active: false)
                channel.ack(_delivery_info.delivery_tag)
            end
        rescue Interrupt => _
            Rails.logger.info('Email Sevice Closed')
            connection.close    
            exit(0)
        end
    
    end
end