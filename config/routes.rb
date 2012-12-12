BedAndBreakfast::Application.routes.draw do


  root :to => "front/performances#last"

  namespace :front do
    resources :pages, :only => [:show]

    resources :performances, :only => [:show] do
      get :last, :on => :collection
      get :extras, :on => :member
      get :video, :on => :member

      resources :videos, :only => [:show]
    end
  end

  namespace :admin do
    match "/" => "performances#index"

    resources :performances, :only => [:index, :new, :create, :edit, :update, :destroy] do
      post :reorder, :on => :collection

      resources :pics do
        post :reorder, :on => :collection
      end
      resources :videos do
        post :reorder, :on => :collection
      end
    end
  end
end
