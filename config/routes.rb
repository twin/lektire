Lektire::Application.routes.draw do
  root to: "home#index"
  get "home/index"

  controller :sessions do
    get "student_login", to: :new_student
    post "student_login", to: :create_student
    get "school_login", to: :new_school
    post "school_login", to: :create_school
    match "logout", to: :destroy
  end

  resource :game

  resources :schools
  resources :students
  resources :quizzes do
    resources :questions
  end

  match "404", to: "errors#not_found"
  match "500", to: "errors#internal_server_error"
end
