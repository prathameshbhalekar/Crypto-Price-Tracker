def stub_get_price_req(symbol = "bitcoin", res_body = '[{"current_price": 1}]')
    stub_request(:get, "https://api.coingecko.com/api/v3/coins/markets?ids=#{symbol}&order=market_cap_desc&page=1&per_page=1&sparkline=false&vs_currency=USD").
        with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
        to_return(status: 200, body: res_body) 
end

def authenticate(username = "test_user", password = "password123")

    post "/auth/login", params: {
      username: username,
      password: password
    }

    body = JSON.parse(response.body)

    return body['data']['token']
end

def stub_authentication(username = "test_user") 
    ApplicationController.any_instance.stub(:decode_jwt).and_return({
        username: username
    })
end