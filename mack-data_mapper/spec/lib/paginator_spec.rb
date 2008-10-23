require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Mack::Database::Paginator do
  
  class Apple
    include ::DataMapper::Resource
    property :id, Serial
    
    def self.default_repository_name
      :in_memory
    end
  end
  # 
  before(:each) do
    Apple.auto_migrate!
    51.times do |i|
      Apple.create
    end
  end
  
  it 'should create 51 Apples' do
    Apple.count.should == 51
  end
  
  it 'should paginate Apples' do
    paginator = Mack::Database::Paginator.new(Apple)
    paginator.paginate.should be_is_a(Mack::Database::Paginator)
    paginator.total_results.should == 51
    paginator.total_pages.should == 6
    paginator.results.should == Apple.all(:order => [:id.asc], :limit => 10)
  end
  
  it 'should paginate Apples desc' do
    paginator = Mack::Database::Paginator.new(Apple, {}, :order => [:id.desc])
    paginator.paginate
    paginator.total_results.should == 51
    paginator.total_pages.should == 6
    paginator.results.should == Apple.all(:order => [:id.desc], :limit => 10)
  end
  
  it 'should paginate Apples with a configurable amount per page' do
    configatron.temp do
      configatron.mack.database.pagination.results_per_page = 5
      paginator = Mack::Database::Paginator.new(Apple)
      paginator.paginate
      paginator.total_results.should == 51
      paginator.total_pages.should == 11
      paginator.results.should == Apple.all(:order => [:id.asc], :limit => 5)
    end
  end
  
  it 'should paginate Apples w/ page 0 == page 1' do
    paginator = Mack::Database::Paginator.new(Apple, :current_page => 0)
    paginator.paginate
    paginator1 = Mack::Database::Paginator.new(Apple, :current_page => 1)
    paginator1.paginate
    paginator.should == paginator1
  end
  
  it 'should paginate Apples should offset pages' do
    paginator = Mack::Database::Paginator.new(Apple, :current_page => 2)
    paginator.paginate
    paginator.total_results.should == 51
    paginator.total_pages.should == 6
    paginator.results.should == Apple.all(:order => [:id.asc], :limit => 10, :offset => 10)
  end
  
  it 'should handle has_next? and has_previous? correctly' do
    paginator = Mack::Database::Paginator.new(Apple)
    paginator.paginate
    paginator.should be_has_next
    paginator.should_not be_has_previous
    
    paginator = Mack::Database::Paginator.new(Apple, :current_page => 2)
    paginator.paginate
    paginator.should be_has_next
    paginator.should be_has_previous
    
    paginator = Mack::Database::Paginator.new(Apple, :current_page => 6)
    paginator.paginate
    paginator.should_not be_has_next
    paginator.should be_has_previous
  end
  
  it 'should paginate Apples w/ page n == the last page' do
    paginator = Mack::Database::Paginator.new(Apple, :current_page => 200)
    paginator.paginate
    paginator.total_results.should == 51
    paginator.total_pages.should == 6
    paginator.current_page.should == 6
    paginator.results.should == Apple.all(:order => [:id.asc], :limit => 10, :offset => 50)
  end
  
  it 'should work directly on the model' do
    paginator = Mack::Database::Paginator.new(Apple)
    paginator.paginate.should == Apple.paginate
  end
  
end