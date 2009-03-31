require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

DB = 'http://localhost:5984/a3tp'

get "/" do
  @links = "<li><a href='/players/all' target=_self>Jogadores</a></li>"
  erb :index
end
 
get '/players/all' do
    data = RestClient.get "#{DB}/_view/players/all"
    players = JSON.parse(data)['rows']
    @links = players.map { |player|
         "<li><a href='/players/"+player['id']+"' target=_self>"+player['value']+"</a></li>"
    }.join    
    erb :index     
   
end

get '/players/:player' do
    data = RestClient.get "#{DB}/#{params[:player]}"
    result = JSON.parse(data)
    @profile = 
        "<ul id='home' title='#{result['short_name']}' selected='true'>
        <h3>##{result['ranking_position']}</h3> 
        <img src='/images/players/#{result['photo']}'>
        Nome:
        #{result['name']}
        <br />
        </ul>"
    erb :player
end
