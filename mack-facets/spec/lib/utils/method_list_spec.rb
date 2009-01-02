require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Mack::Utils::MethodList do
  
  before(:all) do
    if v1_9?
      @method_list = Mack::Utils::MethodList.new([:foo, :bar])
    elsif v1_8?
      @method_list = Mack::Utils::MethodList.new(['foo', 'bar'])
    end
  end
  
  class Foo
  end
  
  it 'should be returned for all the method methods' do
    Foo.methods.should be_kind_of(Mack::Utils::MethodList)
    Foo.new.methods.should be_kind_of(Mack::Utils::MethodList)
  end
  
  it 'should pass methods on to Array' do
    @method_list.size.should eql(2)
  end
  
  describe 'include?' do
    
    it 'should work with either a String or a Symbol' do
      @method_list.should be_include(:foo)
      @method_list.should be_include('foo')
    end
    
  end
  
end