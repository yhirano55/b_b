module BB
  module Evaluator
    class Formula
      EVALUATE_TYPES = %i(between contains equals gt gteq in is lt lteq match).freeze

      attr_reader :value, :operator, :negation

      def initialize(value, options = {})
        @value    = value
        @operator = options[:operator]
        @negation = options[:negation]
      end

      def eval_type
        evaluated_type = EVALUATE_TYPES.detect { |type| send("#{type}?") }

        if !evaluated_type.nil? && negative? && !double_negative?
          :"not_#{evaluated_type}"
        else
          evaluated_type
        end
      end

      private

      def negative?
        negation || operator.to_s.start_with?("not")
      end

      def double_negative?
        negation && operator.to_s.start_with?("not")
      end

      def between?
        value.type == :range
      end

      def contains?
        %i(contains not_contains).include?(operator)
      end

      def equals?
        %i(date numeric string time).include?(value.type) && (operator.nil? || %i(equals not_equals).include?(operator))
      end

      def gt?
        %i(gt not_gt).include?(operator)
      end

      def gteq?
        %i(gteq not_gteq).include?(operator)
      end

      def in?
        %i(array subquery).include?(value.type)
      end

      def is?
        %i(boolean null).include?(value.type)
      end

      def lt?
        %i(lt not_lt).include?(operator)
      end

      def lteq?
        %i(lteq not_lteq).include?(operator)
      end

      def match?
        value.type == :regexp
      end

      class << self
        def eval_type(value, options = {})
          new(value, options).eval_type
        end
      end
    end
  end
end
