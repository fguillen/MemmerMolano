BedAndBreakfast2::Application.routes.draw do
  root :to => "front/performances#last"

  namespace :front do
    resources :performances, :only => [:show] do
      get :last, :on => :collection
      get :extras, :on => :member
      get :video, :on => :member

      resources :videos, :only => [:show]
    end
  end

  namespace :admin do
    resources :performances, :only => [:index, :new, :create, :edit, :update, :destroy] do
      resources :pics do
        post :reorder, :on => :collection
      end
      resources :videos do
        post :reorder, :on => :collection
      end
    end
  end
end
