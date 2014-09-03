class Model < ActiveRecord::Base
	#Empty class
	#Has one field: name (string)
end

class Signup < ActiveRecord::Base
	#Has the following fields declared in the db/migrations
	# name (string)
	# email (string)
	# school (string)
	# cell_number (string)
	# isA (string) (valid answers Hacker, Mentor, Sponsor)

	# This is basically the same API as activerecord enums, but we're using strings to
	# back everything because it makes our lives simpler as far as looking at the db.
	[ "none", "rejected", "cancelled", "accepted", "confirmed", "scheduled" ].each { |value|
		define_method(value + "!") {
			self.status = value
		}

		define_method(value + "?") {
			self.status == value
		}
	}

	def can_confirm_or_cancel
		!self.none? && !self.rejected?
	end

	def rejected_or_accepted
		#self.none is the only state where you haven't been rejected or accepted at some point
		return !self.none?
	end

	def is_accepted_state
		self.accepted? || self.confirmed? || self.scheduled?
	end
end

class MentorSignup < ActiveRecord::Base
end