require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'
require 'named_arguments'


require "#{SCRUBY_DIR}/typed_array" 
require "#{SCRUBY_DIR}/audio/node"
require "#{SCRUBY_DIR}/audio/synth"

include Scruby

describe Synth do
  
  before :all do
    Server = mock('server')
  end
  
  before do
    Node.reset!
    @servers = (0..3).map{ s = mock( 'server'); s.stub!(:send); s }
    @synth = Synth.new( :synth, :attack => 10, :servers => @servers )
  end

  it "should initialize" do
    s = Synth.new( 'synth', :attack => 10, :servers => @servers )
    s.name.should == 'synth'
    s.servers.should == @servers
  end
  
  it "should initialize not passing servers and have default servers" do
    Server.should_receive(:all).and_return(@servers)
    s = Synth.new( 'synth' )
    s.servers.should == @servers
  end
  
  it "should send /s_new message" do
    @servers.each{ |s| s.should_receive(:send).with( '/s_new', ['synth', 2002, 0, 1, :attack, 10] ) }
    s = Synth.new( :synth, :attack => 10, :servers => @servers )
  end
  
  it "should send set message and return self" do
    @servers.each{ |s| s.should_receive(:send).with( '/n_set', [2001, :attack, 20] ) }
    @synth.set( :attack => 20 ).should == @synth
  end

end