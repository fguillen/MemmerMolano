BedAndBreakfast2::Application.routes.draw do
  namespace :admin do
    resources :performances, :only => [:index, :new, :create, :edit, :update, :destroy]
  end
end
