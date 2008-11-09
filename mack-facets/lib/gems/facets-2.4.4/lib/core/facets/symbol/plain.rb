class Symbol

  def plain?
    c = to_s[-1,1]
    !(c == '=' || c == '?')
  end

  def setter?
    to_s[-1,1] == '='
  end

  def query?
    to_s[-1,1] == '?'
  end

end


=begin :spec:

  Quarry.spec Symbol do

    ensure "plain? works" do
      :try.plain?.assert  == true
      :try=.plain?.assert == false
      :try?.plain?.assert == false
    end

    ensure "setter? works" do
      :try.setter?.assert  == false
      :try=.setter?.assert == true
      :try?.setter?.assert == false
    end

    ensure "query? works" do
      :try.query?.assert  == false
      :try=.query?.assert == false
      :try?.query?.assert == true
    end

  end

=end

