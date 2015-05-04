class Release < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true, format: { with: /b[0-9]{4}/,
    message: "release should starts with letter b with 4 digit number, for example: b1505" }
end