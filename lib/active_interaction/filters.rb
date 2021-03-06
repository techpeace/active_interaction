module ActiveInteraction
  # A collection of {Filter}s.
  #
  # @since 0.6.0
  class Filters
    include Enumerable

    def initialize
      @filters = []
    end

    # @return [Enumerator]
    def each(&block)
      @filters.each(&block)
    end

    # @param filter [Filter]
    #
    # @return [Filters]
    def add(filter)
      @filters << filter

      self
    end
  end
end
