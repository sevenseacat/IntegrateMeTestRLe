require "digest"

class MailingList
  class APIError < ::StandardError; end

  attr_reader :id, :name
  
  def self.all
    Gibbon::Request.lists.retrieve.body["lists"].map do |l|
      new(l["id"], l["name"])
    end
  end

  def self.find(id)
    new(id)
  end

  def add_subscriber(details)
    email = details[:email]

    raw_request.members(email_hash(email)).upsert(body: {email_address: email, status: "subscribed",
      merge_fields: { FNAME: details[:given_name], LNAME: details[:family_name]}})
    true
  rescue Gibbon::MailChimpError => e
    raise APIError.new e.body
  end

  private

  def initialize(id, name=nil)
    @id = id
    @name = name
  end

  # The request object should be reinstantiated for each API call.
  # Each request keeps a list of "path parts" and that list resets after each call - but we always
  # want to keep the list details in that path.
  def raw_request
    Gibbon::Request.lists(@id)
  end

  def email_hash(email)
    Digest::MD5.hexdigest email
  end
end
