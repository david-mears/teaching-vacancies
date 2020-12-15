class ABTestSelector
  attr_reader :tests, :user_identifier

  ##
  # Create a new ABTestSelector
  #
  # @param [Hash{Symbol=>Hash{Symbol=>Integer}}] tests A hash of tests to variants with weights
  # @param [Integer] user_identifier A number to identify the user (e.g. numeric IP, user ID)
  def initialize(tests, user_identifier:)
    @tests = tests
    @user_identifier = user_identifier
  end

  ##
  # Picks variants for all tests based on a weighted distribution over the user identifier
  #
  # This allows us to return the same variant for the same user identifier (as long as the
  # test weights do not change).
  #
  # @return [Hash{Symbol=>Symbol}] A hash of all tests to their selected variant
  def selected_variants
    @selected_variants ||= tests.transform_values do |variants|
      index = user_identifier % variants.values.sum
      candidates = variants.flat_map { |variant_name, weight| [variant_name] * weight }

      candidates[index].to_sym
    end
  end

  ##
  # Returns the selected variant for a given test
  #
  # @param [Symbol] test
  #
  # @raise [ArgumentError] if there is no test with that name
  # @return [Symbol] the selected variant
  def variant_for(test)
    selected_variants[test] || raise(ArgumentError, "No such test: #{test}")
  end

  ##
  # Determines whether the current variant for a test matches that provided
  #
  # @param [Symbol] test
  # @param [Symbol] variant
  #
  # @raise [ArgumentError] if there is no test with that name
  # @return [Boolean] whether the current variant for the test and the one given match
  def variant?(test, variant)
    variant_for(test) == variant
  end
end
