require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra"
require 'sinatra/activerecord'

set :database, "sqlite3:db/coufounderMatch.db"

#require_relative './models/task'



enable :sessions

configure :development do
  require 'dotenv'
  Dotenv.load
end

configure :production do

  require 'twilio-ruby'

end


enable :sessions

# create a twilio client using your account info
#@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

get "/sms/incoming" do
    session["last_intent"] ||= nil

    session["counter"] ||= 1
    count = session["counter"]

    sender = params[:From] || ""
    body = params[:Body] || ""
    body = body.downcase.strip

    if session["counter"] == 1
      message = "Hi. I am here to help you find the perfect partner to start a business.  Type 'Looking for cofounder ', 'Share idea', 'About Cofounderbot'"
  end

if body == "Looking for cofounder"
      message = "Ok lets break down your startup idea. what industry does your idea falls under. Is it 'Fintech', 'Healthcare/biotech', 'Data & Analytics', 'consumer goods', 'Education', 'Energy', 'Transportation'?"
      if body == "Fintech" || body == "Healthcare/biotech" || body == "Data and Analytics" || body == "consumer goods" || body == "Education" || body == "Energy" || body == "Transportation"
      # this info first has to be match to the database
          Partner.where(industry: body)
          session[:industry] = body
          message = "Thank you. Now Please tell me something about the problem you are solving. Start with 'to create' or 'to solve'"
        end
      if body == " "
        # this info first has to be saved to the database
        Partner.where(problem: body)
        session[:problem] = body
          message = "Wow thats an awesome idea. So whao are you targeting? Is it for 'Millenials', 'Baby boomers', or 'Everyone'"
        end
      if body =="Millenials" || body == "Baby boomers" || body == "Everyone"
        # this info first has to be saved to the database
        Partner.where(customer: body)
        session[:who] = body
          message = "I think I have the perfect person that you might want to work with. Do you want to connect. Say 'Yes', 'No' or 'Not yet'"
        end
      if body == "yes"
          possible_partners = Partner.where( industry: session[:industry]).where( customer: session[:who] )

          if possible_partners.empty?
            messages = "I couldn't find a match for you. Sorry"
          else
            random_match = possible_partners.sample
            message = "alright you should start a business with" + random_match.name
          end
      elsif body == "No"
          message = "No worries. I am glad to help if you ever need a business partner"
      else message = "Ok take your time. I am here to help if you ever need a business partner. Take care"
        end
elsif body == "share idea"
        message = "Thank you for sharing. If you need me to find a partner, I am here to help you."
elsif body == "about Cofounderbot"
        message = "I am here to listen to your idea and match you with an ideal partner to start a company. To begin, please type 'Looking for cofounder'"
else
  message = "sorry didnt catch that"
end
end
