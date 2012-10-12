require "test_helper"
require "user"

module Cockroach
  class FactoryGirlSourceTest < Test::Unit::TestCase
    setup do
      before_setup
      mock_factory_girl
    end

    teardown do
      after_teardown
    end

    context "Node" do
      setup do
        @lands_node = Cockroach::FactoryGirl::Node.new(
          'places' => {
            'as' => 'lands',
            'amount' => '10'
          })
        @source = Cockroach::Source::Node.new @lands_node
      end

      should "find return nil if no record created yet" do
        assert_nil @source.find 1
      end

      should "random return nil if no record created yet" do
        assert_nil @source.sample
      end

      should "return record with certain id" do
        places = ((1..10).to_a.collect {|i| stub('place', :id => i) })
        ::FactoryGirl.stubs("create").with("place").returns( *places )
        @lands_node.__send__(:load!)

        place_class = stub('place_clase')
        place_class.stubs(:find).with(6).returns(p = places[5])
        factory = @lands_node.instance_variable_get(:@factory)
        factory.stubs(:send).with(:class_name).returns(place_class)

        assert_equal p, @source.find(6)
      end

      should "return random record" do
        places = ((1..10).to_a.collect {|i| stub('place', :id => i) })
        ::FactoryGirl.stubs("create").with("place").returns( *places )
        @lands_node.__send__(:load!)

        place_class = stub('place_clase')
        place_class.stubs(:find).with(any_parameters).returns(p = places.sample)
        factory = @lands_node.instance_variable_get(:@factory)
        factory.stubs(:send).with(:class_name).returns(place_class)

        assert_equal p, @source.sample
      end
    end

    context "Model" do
      setup do
        @old_const = Object.const_get(:Place) if Object.const_defined?(:Place)
        @place = stub('Place')
        silence_warnings { Object.const_set(:Place, @place) }

        @source = Cockroach::Source::Model.new Place
      end

      teardown do
        if @old_const
          silence_warnings { Object.const_set('Place', @old_const) }
        end
      end

      should "return record with certain id" do
        places = ((1..10).to_a.collect {|i| stub('place', :id => i) })
        @place.stubs(:find).with(6).returns(p = places[5])
        
        assert_equal p, @source.find(6)
      end

      should "return random record" do
        places = ((1..10).to_a.collect {|i| stub('place', :id => i) })
        @place.stubs(:order).with("RAND()").returns(@place)
        @place.stubs(:first).returns(p = places.sample)

        assert_equal p, @source.sample
      end
    end
  end
end
