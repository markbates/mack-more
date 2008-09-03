require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Time do

  describe 'random' do
    
    it 'should generate a random time between a start time and now' do
      ago = 90.days.ago
      rtime = Time.random(ago)
      rtime.should be_is_a(Time)
      rtime.should <= Time.now
      rtime.should >= ago
    end
    
    it 'should generate a random time between a start time and now' do
      ago = 90.days.ago
      to = 89.days.ago
      rtime = Time.random(ago, to)
      rtime.should be_is_a(Time)
      rtime.should <= to
      rtime.should >= ago
    end
    
  end

end