require "rails_helper"

RSpec.describe MailingList do
  describe ".all" do
    it "retrieves a list of all mailing lists in the account" do
      stub_request(:get, "https://us18.api.mailchimp.com/3.0/lists")
        .to_return(status: 200, body: File.read(Rails.root.join("spec/support/mailing_lists.json")))

      all_lists = MailingList.all
      expect(all_lists.all? { |l| l.is_a? MailingList }).to eq true
      expect(all_lists.map { |l| [l.id, l.name] }).to eq([
        ["4827de065a", "Email only comp"], ["a94641097a", "Name and email comp"]
      ])
    end
  end

  describe "#add_subscriber" do
    context "when the Mailchimp API responds successfully" do
      before :each do
        # The hash is the lowercase md5 of the email address.
        stub_request(:put, "https://us18.api.mailchimp.com/3.0/lists/123456/members/79005d16381eec2c1195b1f2371f2631")
          .with(body: hash_including(email_address: "tealc@example.com", merge_fields: {
            FNAME: "Teal'c", LNAME: "of Chulak"}))
          .to_return(status: 200)
      end

      it "returns true" do
        expect(MailingList.find("123456").add_subscriber(given_name: "Teal'c",
          family_name: "of Chulak", email: "tealc@example.com")).to eq true
      end

      it "does not error when the same address is subscribed multiple times" do
        2.times { MailingList.find("123456").add_subscriber(given_name: "Teal'c",
          family_name: "of Chulak", email: "tealc@example.com") }
      end
    end

    context "when the Mailchimp API responds with an error" do
      it "rewraps the error and throws it" do
        stub_request(:put, "https://us18.api.mailchimp.com/3.0/lists/123456/members/d41d8cd98f00b204e9800998ecf8427e")
          .with(body: hash_including(email_address: ""))
          .to_return(status: 400)

        expect { MailingList.find("123456").add_subscriber(email: "") }
          .to raise_error(MailingList::APIError)
      end
    end
  end
end
