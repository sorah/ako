Ako::Application.routes.draw do
  root 'dashboard#index'

  resources :bills

  resources :places do
    collection do
      post :candidates_for_expense
    end
  end

  resources :categories

  resources :accounts

  resources :expenses do
    collection do
      post "candidates_for_bill(/:bill_id)" => 'expenses#candidates_for_bill'
    end
  end

  get 'report' => 'report#monthly_index', as: :monthly_report_index
  get 'report/weekly' => 'report#weekly_index', as: :weekly_report_index

  get 'report/:year/:month' => 'report#monthly', as: :monthly_report
  get 'report/:year/:month/w/:weekno' => 'report#weekly', as: :weekly_report
  get 'report/:year/:month/:day' => 'report#daily', as: :daily_report


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
