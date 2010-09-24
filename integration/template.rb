require_relative 'setup'
describe "basic template" do
  behaves_like :integration
  it "should create a new one" do
    result = run!(nil)
    result.config.has_key?('workflows').should.be.true
    result.config.has_key?('projects').should.be.true
  end

  it "should not overwrite an existing one" do
    run!(foo: :bar).config.should == {foo: :bar}
  end
end
