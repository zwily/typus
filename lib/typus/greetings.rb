module Typus

  @@greetings = { "Moyo" => "Tshiluba", 
                  "Bangawoyo" => "Korean", 
                  "Ni hao" => "Mandarin", 
                  "Hala" => "Arabic", 
                  "Sawubona" => "Zulu", 
                  "G'day" => "Australian", 
                  "Yasou" => "Greek", 
                  "Góðan daginn" => "Icelandic", 
                  "Tere" => "Estonian", 
                  "Hej" => "Swedish", 
                  "Merhaba" => "Turkish", 
                  "Hola" => "Spanish", 
                  "Hello" => "English", 
                  "Konnichiwa" => "Japanese", 
                  "Kumusta" => "Tagalog", 
                  "Aloha" => "Hawaiian", 
                  "Salut" => "French" }.to_a

  mattr_accessor :greetings

end