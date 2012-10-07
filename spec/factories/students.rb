# encoding: utf-8

FactoryGirl.define do
  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade 2
    gender "Muško"
    year_of_birth 1991
    username "jon"
    password "jon"
    school

    factory :janko do
      first_name "Janko"
      last_name "Marohnić"
      username "janko"
      password "janko"
    end

    factory :matija do
      first_name "Matija"
      last_name "Marohnić"
      username "matija"
      password "matija"
    end
  end
end