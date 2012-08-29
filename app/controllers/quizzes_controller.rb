# encoding: utf-8

class QuizzesController < ApplicationController
  def index
    @quizzes = current_school.quizzes
  end

  def new
    @quiz = current_school.quizzes.new
  end

  def create
    @quiz = current_school.quizzes.create(params[:quiz])

    if @quiz.valid?
      redirect_to quizzes_path, notice: "Kviz je uspješno stvoren."
    else
      render :new
    end
  end

  def show
    @quiz = current_school.quizzes.find(params[:id])
  end

  def edit
    @quiz = current_school.quizzes.find(params[:id])
  end

  def update
    @quiz = current_school.quizzes.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      if params[:commit]
        redirect_to @quiz, notice: "Kviz je uspješno izmjenjen."
      else
        redirect_to quizzes_path
      end
    else
      render :new
    end
  end

  def destroy
    quiz = current_school.quizzes.destroy(params[:id]).first
    redirect_to quizzes_path, notice: "Kviz \"#{quiz.name}\" je uspješno izbrisan."
  end
end