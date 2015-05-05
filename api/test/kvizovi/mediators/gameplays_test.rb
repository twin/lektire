require "unit"
require "kvizovi/mediators/gameplays"

Gameplays = Kvizovi::Mediators::Gameplays

class GameplaysTest < UnitTest
  def setup
    @user = create(:janko)
    @quiz = create(:quiz, creator: @user)
    @gameplays = Gameplays.new(@user)
  end

  def create_gameplay
    Gameplays.create(
      attributes_for(:gameplay,
        links: {
          quiz: {linkage: {type: :quizzes, id: @quiz.id}},
          players: {linkage: [{type: :users, id: @user.id}]},
        }
      )
    )
  end

  def test_creating
    gameplay = create_gameplay

    assert gameplay.exists?
    assert_equal @quiz, gameplay.quiz
    assert_equal [@user], gameplay.players
  end

  def test_searching_as_creator
    gameplay = create_gameplay
    gameplay.players_dataset.delete

    assert_equal [gameplay], @gameplays.search(as: "creator").to_a
    assert_equal [gameplay], @gameplays.search(as: "creator", quiz_id: @quiz.id).to_a
    assert_equal [],         @gameplays.search(as: "creator", quiz_id: -1).to_a
  end

  def test_searching_as_player
    gameplay = create_gameplay
    gameplay.quiz.delete

    assert_equal [gameplay], @gameplays.search(as: "player").to_a
    assert_equal [gameplay], @gameplays.search(as: "player", quiz_id: @quiz.id).to_a
    assert_equal [],         @gameplays.search(as: "player", quiz_id: -1).to_a
  end

  def test_pagination
    gameplay1 = create_gameplay
    gameplay2 = create_gameplay

    assert_equal [gameplay1], @gameplays.search(as: "creator", page: {number: 1, size: 1}).to_a
    assert_equal [gameplay2], @gameplays.search(as: "creator", page: {number: 2, size: 1}).to_a
  end

  def test_find
    gameplay = create_gameplay

    assert_equal gameplay, @gameplays.find(gameplay.id)
  end
end