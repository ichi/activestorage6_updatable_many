require 'activestorage6_updatable_many/version'

ActiveSupport.on_load(:active_record) do
  require 'active_storage/attached'
  require 'activestorage6_updatable_many/attached/model'

  # if use activestorage6
  if defined?(ActiveStorage::Attached::Changes)
    ActiveRecord::Base.singleton_class.prepend(Activestorage6UpdatableMany::Attached::Model)
  end
end
