Rails.application.routes.draw do
  post 'auth/signup'
  post 'auth/login'

  post 'alerts/create'
  get 'alerts/allAlerts'
  delete 'alerts/deleteAlert'

end
