module Activestorage6UpdatableMany
  module Attached
    module Model

      def has_many_attached(name, dependent: :purge_later)
        super.tap do
          generated_association_methods.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name}_updatable
              @active_storage_attached_#{name}_updatable ||= Activestorage6UpdatableMany::Attached::UpdatableMany.new("#{name}", self)
            end

            def #{name}_updatable_attachments=(attachables)
              attachment_changes["#{name}_updatable"] ||= Activestorage6UpdatableMany::Attached::Changes::UpdateMany.new("#{name}", self, [])

              updatables = Activestorage6UpdatableMany::Attached::Changes::UpdateMany.new("#{name}", self, attachables, :attachments)
              attachment_changes["#{name}_updatable"].merge!(updatables)
            end

            def #{name}_updatable_files=(attachables)
              attachment_changes["#{name}_updatable"] ||= Activestorage6UpdatableMany::Attached::Changes::UpdateMany.new("#{name}", self, [])

              updatables = Activestorage6UpdatableMany::Attached::Changes::UpdateMany.new("#{name}", self, attachables, :files)
              attachment_changes["#{name}_updatable"].merge!(updatables)
            end
          CODE

          after_save { attachment_changes["#{name}_updatable"]&.save }

          after_commit(on: %i[ create update ]) { attachment_changes.delete("#{name}_updatable").try(:upload) }
        end
      end

    end
  end
end
