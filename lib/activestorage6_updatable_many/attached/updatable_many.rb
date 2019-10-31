module Activestorage6UpdatableMany
  module Attached
    class UpdatableMany < ActiveStorage::Attached::Many

      private

      def change
        record.attachment_changes["#{name}_updatable"]
      end
    end
  end
end
