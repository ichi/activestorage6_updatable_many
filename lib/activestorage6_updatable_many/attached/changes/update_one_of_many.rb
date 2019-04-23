module Activestorage6UpdatableMany
  class Attached::Changes::UpdateOneOfMany #:nodoc:
    attr_reader :name, :record, :attachable

    def initialize(name, record, attachable)
      @name, @record, @attachable = name, record, attachable
    end

    def attachment
      @attachment ||= find_attachment || build_attachment unless marked_for_destruction?
    end

    def blob
      @blob ||= find_blob
    end

    def upload
    end

    def save
    end

    private

      def find_attachment
        record.public_send("#{name}_attachments").detect{|attachment| attachment.id == attachable[:id].to_i }.tap do |attachment|
          attachment&.assign_attributes(attachable.except(:_destroy))
        end
      end

      def build_attachment
        ActiveStorage::Attachment.new(record: record, name: name, blob: blob) if blob
      end

      def find_blob
        ActiveStorage::Blob.where(id: attachable[:blob_id]).first unless attachable[:blob_id].blank?
      end

      def marked_for_destruction?
        ActiveRecord::Type::Boolean.new.cast(attachable[:_destroy])
      end
  end
end
