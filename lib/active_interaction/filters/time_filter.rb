module ActiveInteraction
  class Base
    # Creates accessors for the attributes and ensures that values passed to
    #   the attributes are Times. Numeric values are processed using `at`.
    #   Strings are processed using `parse` unless the format option is given,
    #   in which case they will be processed with `strptime`. If `Time.zone` is
    #   available it will be used so that the values are time zone aware.
    #
    # @macro filter_method_params
    # @option options [String] :format parse strings using this format string
    #
    # @example
    #   time :start_date
    #
    # @example
    #   date_time :start_date, format: '%Y-%m-%dT%H:%M:%S%z'
    #
    # @since 0.1.0
    #
    # @method self.time(*attributes, options = {})
  end

  # @private
  class TimeFilter < AbstractDateTimeFilter
    def cast(value)
      case value
      when Numeric
        time.at(value)
      else
        super
      end
    end

    private

    def klass
      time.at(0).class
    end

    def time
      if Time.respond_to?(:zone) && !Time.zone.nil?
        Time.zone
      else
        Time
      end
    end
  end
end
