gem 'activerecord'

##
# &copy; 2010 Andrew Coleman
# Released under MIT license.
# http://www.opensource.org/licenses/mit-license.php
#
module ActsAsRetired
  def acts_as_retired
    class_eval do
      named_scope :deleted, :conditions => "#{table_name}.deleted_at IS NOT NULL"
      named_scope :active, :conditions => { :deleted_at => nil }
      
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
        active.all(:order => 'name ASC').collect do |gramps|
          [ gramps.name, gramps.id.to_s ]
        end
      end
      
      def self.options_from_filter_params(filter)
        conds = []
        conds << retired_filter_conditions(filter)
        
        { :conditions => conds.compact.join(' AND ') }
      end
      
      def self.retired_filter_conditions(filter)
        if filter[:include_deleted].to_i == 1
          nil
        else
          "#{table_name}.deleted_at IS NULL"
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, ActsAsRetired
