class Model < ActiveRecord::Base
	#Empty class
	#Has one field: name (string)
end

class Signup < ActiveRecord::Base
	#Has the following fields: 
	# name (string)
	# email (string)
	# school (string)
	# cell_number (string)
	# isA (string) (valid answers Hacker, Mentor, Sponsor)
end