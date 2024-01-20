# frozen_string_literal: true

require_relative "test_helper"
require "minitest/spec"
require "minitest/autorun"
if ENV["RUBY_CI_SECRET_KEY"]
  require "rspec/core/runner"
  require "ruby_ci/runner_prepend"

  class RSpec::Core::ExampleGroup
    def self.filtered_examples
      rubyci_scoped_ids = Thread.current[:rubyci_scoped_ids] || ""

      RSpec.world.filtered_examples[self].filter do |ex|
        rubyci_scoped_ids == "" || /^#{rubyci_scoped_ids}($|:)/.match?(ex.metadata[:scoped_id])
      end
    end
  end

  RSpec::Core::Runner.prepend(RubyCI::RunnerPrepend)
end
Minitest::Spec.register_spec_type(/Controller$/, ActionDispatch::IntegrationTest)

require_relative "support/api_controller_test"
