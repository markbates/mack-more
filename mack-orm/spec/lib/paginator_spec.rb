require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Mack::Database::Paginator do
  
  class Apple
  end
  
  it 'should handle has_next? and has_previous? correctly' do
    paginator = Mack::Database::Paginator.new(Apple)
    paginator.current_page = 1
    paginator.total_pages = 6
    paginator.should be_has_next
    paginator.should_not be_has_previous
    
    paginator.current_page = 2
    paginator.should be_has_next
    paginator.should be_has_previous
    
    paginator.current_page = 6
    paginator.should_not be_has_next
    paginator.should be_has_previous
  end
  
  describe 'start_index and end_index' do
    
    it 'should properly tell you where the results start and end' do
      paginator = Mack::Database::Paginator.new(Apple)
      paginator.total_results = 56
      paginator.total_pages = 6
      paginator.results_per_page = 10
      
      paginator.current_page = 1
      paginator.start_index.should == 1
      paginator.end_index.should == 10
      
      paginator.current_page = 2
      paginator.start_index.should == 11
      paginator.end_index.should == 20
      
      paginator.current_page = 6
      paginator.start_index.should == 51
      paginator.end_index.should == 56
      
      paginator.total_results = 1
      paginator.total_pages = 1
      paginator.results_per_page = 10
      paginator.current_page = 1
      paginator.start_index.should == 1
      paginator.end_index.should == 1
      
      paginator.total_results = 0
      paginator.total_pages = 0
      paginator.results_per_page = 10
      paginator.current_page = 1
      paginator.start_index.should == 0
      paginator.end_index.should == 0
      
      paginator.total_results = 0
      paginator.total_pages = 1
      paginator.results_per_page = 10
      paginator.current_page = 1
      paginator.start_index.should == 0
      paginator.end_index.should == 0
    end
    
  end

  
end