class TypusUser < ActiveRecord::Base

  attr_accessor :password

  validates_presence_of :email
  validates_presence_of :password, :password_confirmation, :if => :new_record?
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_confirmation_of :password, :if => lambda { |person| person.new_record? or not person.password.blank? }
  validates_length_of :password, :within => Typus::Configuration.options[:password]..40, :if => lambda { |person| person.new_record? or not person.password.blank? }

  validates_inclusion_of :roles, 
                         :in => Typus::Configuration.roles.keys, 
                         :message => "has to be in #{Typus::Configuration.roles.keys.reverse.join(", ")}."

  before_create :set_token
  before_save :encrypt_password

  def full_name(role = false)
    if !first_name.empty? && !last_name.empty?
      full_name = "#{first_name} #{last_name}"
    else
      full_name ="#{email}"
    end
    full_name << " (#{roles})" if role
  end

  def reset_password
    TypusMailer.deliver_reset_password_link(self)
  end

  def self.authenticate(email, password)
    user = find_by_email_and_status(email, true)
    user && user.authenticated?(password) ? user : nil
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  ##
  # Models the user has access to ...
  #
  def models
    calculate = {}
    self.roles.split(', ').each do |role|
      calculate = Typus::Configuration.roles[role].compact
    end
    return calculate
  rescue
    "All"
  end

  def can_create?(model)
    self.models[model.to_s].include? "c"
  end

  def can_read?(model)
    self.models[model.to_s].include? "r"
  end

  def can_update?(model)
    self.models[model.to_s].include? "u"
  end

  def can_destroy?(model)
    self.models[model.to_s].include? "d"
  end

protected

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def encrypt(password)
    Digest::SHA1.hexdigest("--#{salt}--#{password}")
  end

  def set_token
    record = "#{self.class.name}#{id}"
    @attributes['token'] = CGI::Session.generate_unique_id(record).first(12)
  end

end