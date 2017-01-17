require 'rails_helper'
require 'webmock/rspec'

describe CollectStats do
  before :each do
    Redis.current = MockRedis.new
  end
  it "collects the stats from icecast's xml" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      CollectStats.new(radio).perform
      expect(Listen.count).to eq 2
    end
  end

  it "doesn't record a new listener if the listener is still connected" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      CollectStats.new(radio).perform
      expect(Listen.count).to eq 2
      CollectStats.new(radio).perform
      expect(Listen.count).to eq 2
    end
  end

  it "records the end_at if the listener is no longer connected" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    # two listeners connected
    stub_request(:get, "http://localhost:8000/admin/listmounts?with_listeners").to_return(body: File.read("spec/fixtures/xml/two_listeners.xml"))
    CollectStats.new(radio).perform
    expect(Listen.count).to eq 2

    # no listeners connected
    stub_request(:get, "http://localhost:8000/admin/listmounts?with_listeners").to_return(body: File.read("spec/fixtures/xml/no_listeners.xml"))
    end_time = Time.now
    Timecop.freeze(end_time)
    CollectStats.new(radio).perform
    expect(Listen.count).to eq 2
    Listen.all.each do |listen|
      expect(listen.end_at).to eq end_time
    end
    Timecop.return
  end
end
