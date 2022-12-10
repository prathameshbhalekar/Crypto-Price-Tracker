require 'faye/websocket'
require 'eventmachine'
require 'bunny'

namespace :binance_listner do
    desc 'Listen to binance websocket and push messages to queue'
    task :listen do
      
      connection = Bunny.new(hostname: ENV["RABBITMQ_HOST"])
      channel = nil
      queue = nil

      EM.run {
        ws = Faye::WebSocket::Client.new('wss://stream.binance.com:443/ws/btcusdt@aggTrade')

        ws.on :open do |event|
          connection.start
          channel = connection.create_channel
          queue = channel.queue('BINANCE_MESSAGES')
          Rails.logger.info('Connected to Binance websocket')
        end

        ws.on :message do |event|
          channel.default_exchange.publish(event.data, routing_key: queue.name)
        end

        ws.on :close do |event|
          connection.close
          Rails.logger.info(['Disconnected from Binance websocket', event.code, event.reason])
          ws = nil
        end
      }
    
    end
  end