FashionFly::Application.routes.draw do

  get "thanks" => "thanks#index", :as => 'thanks'

  get "notice/registration", :as => "registration_notice"

  post "checkout/notify_buy" => "checkout#notify_buy_paypal", :as => :notify_buy
  post "checkout/notify_buy_auctions" => "checkout#notify_auctions_paypal", :as => :notify_buy_auctions 
  get "checkout/paypal_auctions" => 'checkout#pay_auctions', :as => :paypal_auctions
  get "checkout/paypal_buy" => 'checkout#buy_bids', :as => :paypal_buy

  get "auctionValues" => "auctions#auction_information", :as => :auctionValues

  resources :auctions do
    resource :order
  end

  resource :luckyloser

  get 'category/:name' => 'categories#show', :as => 'category'

  get "buy_bid" => 'payment#buy'

  get 'page/:name' => "pages#show", as: 'page'
  
  post 'actionUpdate' => 'auctions#update_values'

  post 'timerUpdate' => 'auctions#timer_update'

  post 'bid_auction' => "auctions#bid"

  get 'orders' => 'orders#index', :as => 'orders'

  devise_for :users, :controllers => {:registrations => 'registration'}
  
  namespace :admin do
    resources :auctions
    resources :auction_configurations
    resources :products
    resources :pages
    resources :users
    resources :orders
    resources :partners
    root :to => 'auctions#index'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web, at: "/sidekiq"


  root :to => 'welcome#index'

  get "invite_user" => "invites#show"

  match "*path" => redirect("/")
end
