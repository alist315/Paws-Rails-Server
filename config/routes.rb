Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get '/pets', to: 'pets#index'
get '/pets/:id', to: 'pets#show'
post '/pets', to: 'pets#create'
delete '/pets/:id', to: 'pets#delete'
put '/pets/:id', to: 'pets#update'
end
