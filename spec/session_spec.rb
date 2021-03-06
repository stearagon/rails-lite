require 'webrick'
require_relative '../lib/session'
require_relative '../lib/controller_base'

describe Session do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cook) { WEBrick::Cookie.new('my_rails', { xyz: 'abc' }.to_json) }

  it "deserializes json cookie if one exists" do
    req.cookies << cook
    session = Session.new(req)
    expect(session['xyz']).to eq('abc')
  end

  describe "#store_session" do
    context "without cookies in request" do
      before(:each) do
        session = Session.new(req)
        session['first_key'] = 'first_val'
        session.store_session(res)
      end

      it "adds new cookie with 'my_rails' name to response" do
        cookie = res.cookies.find { |c| c.name == 'my_rails' }
        expect(cookie).not_to be_nil
      end

      it "stores the cookie in json format" do
        cookie = res.cookies.find { |c| c.name == 'my_rails' }
        expect(JSON.parse(cookie.value)).to be_instance_of(Hash)
      end
    end

    context "with cookies in request" do
      before(:each) do
        cook = WEBrick::Cookie.new('my_rails', { pho: "soup" }.to_json)
        req.cookies << cook
      end

      it "reads the pre-existing cookie data into hash" do
        session = Session.new(req)
        expect(session['pho']).to eq('soup')
      end

      it "saves new and old data to the cookie" do
        session = Session.new(req)
        session['machine'] = 'mocha'
        session.store_session(res)
        cookie = res.cookies.find { |c| c.name == 'my_rails' }
        h = JSON.parse(cookie.value)
        expect(h['pho']).to eq('soup')
        expect(h['machine']).to eq('mocha')
      end
    end
  end
end

describe ControllerBase do
  before(:all) do
    class CatsController < ControllerBase
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { CatsController.new(req, res) }

  describe "#session" do
    it "returns a session instance" do
      expect(cats_controller.session).to be_a(Session)
    end

    it "returns the same instance on successive invocations" do
      first_result = cats_controller.session
      expect(cats_controller.session).to be(first_result)
    end
  end

  shared_examples_for "storing session data" do
    it "should store the session data" do
      cats_controller.session['test_key'] = 'test_value'
      cats_controller.send(method, *args)
      cookie = res.cookies.find { |c| c.name == 'my_rails' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to eq('test_value')
    end
  end

  describe "#render_content" do
    let(:method) { :render_content }
    let(:args) { ['test', 'text/plain'] }
    include_examples "storing session data"
  end

  describe "#redirect_to" do
    let(:method) { :redirect_to }
    let(:args) { ['http://appacademy.io'] }
    include_examples "storing session data"
  end
end
