gem 'activerecord'

##
# &copy; 2010 Andrew Coleman
# Released under MIT license.
# http://www.opensource.org/licenses/mit-license.php
#
module ActsAsRetired
  def acts_as_retired
    class_eval do
      named_scope :deleted, -> { where("#{table_name}.deleted_at IS NOT NULL") }
      named_scope :active,  -> { where(deleted_at: nil) }
      
      def destroy
        unless self.new_record?
          time_stamp = Time.zone ? Time.zone.now : Time.now
          update_attribute :deleted_at, time_stamp
        end
        freeze
      end
      
      def undestroy
        update_attribute :deleted_at, nil
      end
      
      def self.for_select
        active.order('name ASC').all.map do |gramps|
          [ gramps.name, gramps.id.to_s ]
        end
      end
      
      def self.options_from_filter_params(filter)
        retired_filter_conditions(filter)
      end
      
      def self.retired_filter_conditions(filter)
        if filter[:include_deleted].to_i == 1
          scoped
        else
          scoped.active
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, ActsAsRetired
