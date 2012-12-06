BedAndBreakfast2::Application.routes.draw do
  namespace :admin do
    resources :performances, :only => [:index, :new, :create, :edit, :update, :destroy] do
      resources :pics
    end
  end
end