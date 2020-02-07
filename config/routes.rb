Rails.application.routes.draw do
  namespace :contacts do
    # Allow tag names to include dots.
    get "/tags/:tag", action: :tag, constraints: { tag: /[^\/]+/ }, as: :tag
  end

  resources :contacts, controller: "contacts" do
    collection do
      get :current_clients
      get :former_clients
      get :prospects
      get :no_notes
    end
  end
  resources :notes, :except => [:index], controller: "notes"

  get "/" => "contacts#index"
end
