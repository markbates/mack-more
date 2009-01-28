require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe 'Duration' do

  describe 'ago' do
    
    it 'should return a duration that is in the past' do
      ago = 90.days.ago
      ago.should be_kind_of(Time)
      ago.should < Time.now
    end
    
  end
  
  describe 'from_now' do
    
    it 'should return a duration that is in the future' do
      from_now = 90.days.from_now
      from_now.should be_kind_of(Time)
      from_now.should > Time.now
    end
    
  end

end