Rails.application.routes.draw do
  get 'comments/create'
  get 'rewards/index'
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :revote
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, concerns: %i[votable], shallow: true do
      member do
        post :choose_best
      end
      resources :comments
    end
    resources :comments
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  # mount ActionCable.server, at: '/cable'
end
