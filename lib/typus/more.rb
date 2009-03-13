module Typus

  def self.to_sentence_options
    if Rails.version == '2.2.2'
      { :skip_last_comma => true, :connector => '&' }
    else
      { :words_connector => ', ', :last_word_connector => ' & ' }
    end
  end

end