require 'activestorage6_updatable_many/attached/changes/update_one_of_many'

module Activestorage6UpdatableMany
  class Attached::Changes::UpdateMany < ActiveStorage::Attached::Changes::CreateMany
    attr_reader :context

    def initialize(name, record, attachables, context = nil)
      super(name, record, normalize_attachables(attachables))
      @context = context
    end

    def attachments
      super.compact
    end

    def blobs
      super.compact
    end

    def merge!(other)
      raise ArgumentError, "Name and record must be matched." unless name == other.name && record == other.record

      @subchanges = subchanges + other.send(:subchanges)
      self
    end

    private
      def build_subchange_from(attachable)
        case context
        when :attachments
          Activestorage6UpdatableMany::Attached::Changes::UpdateOneOfMany.new(name, record, attachable)
        when :files
          ActiveStorage::Attached::Changes::CreateOneOfMany.new(name, record, attachable)
        end
      end

      def normalize_attachables(attachables)
        if attachables.respond_to?(:permitted?)
          attachables = attachables.to_h
        end

        unless attachables.is_a?(Hash) || attachables.is_a?(Array)
          raise ArgumentError, "Hash or Array expected for attribute `#{attachables}`, got #{attachables.class.name} (#{attachables.inspect})"
        end

        if attachables.is_a? Hash
          keys = attachables.keys
          attachables =
            if keys.include?("id") || keys.include?(:id)
              [attachables]
            else
              attachables.values
            end
        end

        attachables
      end
  end
end
