Rails.application.routes.draw do
  root 'static_pages#home', as: :home
  get '/progress', to: 'static_pages#progress', as: :progress
  resources :assessments
  resources :exams do
    member do
      get :grade
      post :post_grades
    end
  end
  resources :attempts
  resources :standards
  resources :students do
    member do
      get :grade
      post :post_grades
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
