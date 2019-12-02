Rails.application.routes.draw do

  resources :signup do
    collection do
      get 'step1'
      get 'step2'
      get 'step3'
      get 'step4'
      # get 'step5' # ここで、入力の全てが終了する
      get 'done'
      get 'logout'
    end
  end

  delete '/logout', to: 'signup#destroy'


  devise_for :users
  root 'items#index'

  resources :items, only: [:new, :create]

  resources :users, only: [:show, :create] do
    collection do
      get :profile
      get :credit
      get :identification
      post :identification_2
    end
  end

end
