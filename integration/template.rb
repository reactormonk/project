require_relative 'setup'
describe "basic template" do
  behaves_like :integration
  it "should create a new one" do
    run!(false) do |result|
      result.config.has_key?('workflows').should.be.true
      result.config.has_key?('projects').should.be.true
    end
  end

  it "should not overwrite an existing one" do
    run!(foo: :bar) do |result|
      result.config.should == {foo: :bar}
    end
  end
end
