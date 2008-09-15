require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::SessionStore::DataMapper do
  
  class SessHelper # :nodoc:
    attr_accessor :session
  end
  
  before(:each) do
    Mack::Database.establish_connection
    Mack::DataMapper::Session.auto_migrate!
    @session = Mack::Session.new('1234')
    @session[:user_id] = 1
  end
  
  describe "get" do
    
    it "should return nil if the session doesn't exist" do
      Mack::SessionStore::DataMapper.get('salkdfjsdlf').should be_nil
    end
    
    it "should return the session if it already exists" do
      lambda {
        Mack::DataMapper::Session.create(:id => @session.id, :data => @session)
      }.should change(Mack::DataMapper::Session, :count).by(1)
      n_sess = Mack::SessionStore::DataMapper.get(@session.id)
      n_sess.should be_is_a(Mack::Session)
      n_sess[:user_id].should == @session[:user_id]
    end
    
    it "should delete the session if it's 'expired'" do
      temp_app_config(:mack => {:data_mapper_session_store => {:expiry_time => 2.seconds}}) do
        Mack::DataMapper::Session.create(:id => @session.id, :data => @session)
        n_sess = Mack::SessionStore::DataMapper.get(@session.id)
        n_sess.should be_is_a(Mack::Session)
        n_sess[:user_id].should == @session[:user_id]
        sleep(4)
        Mack::SessionStore::DataMapper.get(@session.id).should be_nil
      end
    end
    
  end
  
  describe "set" do
    
    it "should create a new session if it didn't exist" do
      lambda {
        sh = SessHelper.new
        sh.session = @session
        Mack::SessionStore::DataMapper.set(@session.id, sh)
        n_sess = Mack::SessionStore::DataMapper.get(@session.id)
        n_sess.should be_is_a(Mack::Session)
        n_sess[:user_id].should == @session[:user_id]
      }.should change(Mack::DataMapper::Session, :count).by(1)
    end
    
    it "should update a session that previously exists" do
      sh = SessHelper.new
      sh.session = @session
      lambda {
        Mack::SessionStore::DataMapper.set(@session.id, sh)
      }.should change(Mack::DataMapper::Session, :count).by(1)
      n_sess = Mack::SessionStore::DataMapper.get(@session.id)
      n_sess.should be_is_a(Mack::Session)
      n_sess[:user_id].should == @session[:user_id]
      sh.session[:user_id] = 2
      Mack::SessionStore::DataMapper.set(@session.id, sh)
      n_sess = Mack::SessionStore::DataMapper.get(@session.id)
      n_sess.should be_is_a(Mack::Session)
      n_sess[:user_id].should == 2
    end
    
  end
  
  describe "expire" do
    
    it "should delete a specific session" do
      lambda {
        Mack::DataMapper::Session.create(:id => @session.id, :data => @session)
      }.should change(Mack::DataMapper::Session, :count).by(1)
      lambda {
        Mack::SessionStore::DataMapper.expire(@session.id)
      }.should change(Mack::DataMapper::Session, :count).by(-1)
      lambda {
        Mack::SessionStore::DataMapper.expire('abcdesdf')
      }.should change(Mack::DataMapper::Session, :count).by(0)
    end
    
  end
  
  describe "expire_all" do
    
    it "should delete all the sessions in the db" do
      lambda {
        3.times do |i|
          Mack::DataMapper::Session.create(:id => i, :data => Mack::Session.new(i))
        end
      }.should change(Mack::DataMapper::Session, :count).by(3)
      Mack::DataMapper::Session.count.should == 3
      Mack::SessionStore::DataMapper.expire_all
      Mack::DataMapper::Session.count.should == 0
    end
    
  end
  
end