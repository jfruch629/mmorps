require "sinatra"
require "pry"
require "capybara"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do
  if session[:visit_count].nil?
    session[:game_over] = false
    session[:visit_count] = 1
  else
    session[:visit_count] += 1
  end

  if session[:player_score].nil?
    session[:player_score] = 0
    session[:computer_score] = 0
  end

  if session[:player_score] == 3
    session[:game_over] = true
    session[:final_message] = "Player wins!"
  elsif session[:computer_score] == 3
    session[:game_over] = true
    session[:final_message] = "Computer wins!"
  end
  erb :index
end

post '/choice' do
  session[:player_choice] = params[:player_choice]
  session[:computer_choice] = ["Rock","Paper","Scissors"].sample

  if session[:player_choice] == "Rock" && session[:computer_choice] == "Scissors"
    session[:player_score] += 1
    session[:message] = "Player chose Rock, and Computer chose Scissors. Rock beats Scissors, Player wins the round!!"
  elsif session[:player_choice] == "Paper" && session[:computer_choice] == "Rock"
    session[:message] = "Player chose Paper, and Computer chose Rock. Paper covers Rock, Player wins the round!"
    session[:player_score] += 1
  elsif session[:player_choice] == "Scissors" && session[:computer_choice] == "Paper"
    session[:message] = "Player chose Scissors, and Computer chose Paper. Scissors cuts Paper, Player wins the round!"
    session[:player_score] += 1
  elsif session[:player_choice] == "Scissors" && session[:computer_choice] == "Rock"
    session[:message] = "Player chose Scissors, and Computer chose Rock. Rock beats Scissors, Computer wins the round!"
    session[:computer_score] += 1
  elsif session[:player_choice] == "Rock" && session[:computer_choice] == "Paper"
    session[:message] = "Player chose Rock, and Computer chose Paper. Paper covers Rock, Computer wins the round!"
    session[:computer_score] += 1
  elsif session[:player_choice] == "Paper" && session[:computer_choice] == "Scissors"
    session[:message] = "Player chose Paper, and Computer chose Scissors. Scissors cuts paper, Computer wins the round!"
    session[:computer_score] += 1
  elsif session[:player_choice] == session[:computer_choice]
    session[:message] = "Both Player and Computer chose #{session[:player_choice]}. It's a tie!"
  elsif session[:player_choice] == "Play Again"
    session.clear
  end
  redirect '/'
end
