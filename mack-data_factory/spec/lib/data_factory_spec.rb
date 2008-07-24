require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "DataFactory" do
  
  describe "Module" do
    it "should add create class_method to the factory object"
    it "should add field class_method to the factory object"
  end
  
  describe "With no override" do
    it "should generate default values for the model"
    it "should generate correct relationship for the model"
    it "should generate correct value type for each attribute in the model"
    it "should generate x number of instances properly"
  end
  
  describe "With override" do
    it "should generate default values for the model (minus the override)"
    it "should generate the value correctly based on the override rules"
    it "should generate correct relationship if relationship override rule is provided"
    it "should generate correct relationship if relationship override rule is not provided"
    it "should generate x number of instances properly"
  end
  
  describe "Custom rules" do
    it "should generate 100 bytes of random string if :length is set"
    it "should generate 100 bytes of random string with spaces in between if :length and :add_space are set"
    it "should generate up to 100 bytes of random string if :max_length (and ignore :length)"
    it "should generate minimum of 100 bytes of random string if :min_length (and ignore :length) "
    it "should generate from 100-500 bytes of random string if :min and :max_length is set (and ignore :length)"
    it "should generate up to 100 bytes of random string with spaces if :add_space and :max_length (and ignore :length)"
    it "should generate minimum of 100 bytes of random string with spaces if :add_space and :min_length (and ignore :length) "
    it "should generate from 100-500 bytes of random string with spaces if :add_space and :min and :max_length is set (and ignore :length)"
    it "should only generate alphabets in the random string if :content is set to :alpha"
    it "should only generate numerics in the random string if :content is set to :numeric"
    it "should only generate alphanumerics in the random string if :content is set to :alpha_numeric"
    it "should have 0% of null value occurrences if :null_frequency is set to 0"
    it "should have 100% of null value occurrences if :null_frequency is set to 100"
    it "should have about 20% of null value occurrences if :null_frequency is set to 20"
    it "should generate the same value accross all instances if :immutable is set"
  end
  
end