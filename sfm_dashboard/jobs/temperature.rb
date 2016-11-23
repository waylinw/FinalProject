require 'mysql2'

points = []

SCHEDULER.every '2s', :first_in => 0 do |job|

  # mysql connection
  db = Mysql2::Client.new(host: "localhost", username: "root", password: "root", database: "sfm")

  # mysql query
  sql = "SELECT * FROM Data LIMIT 1"

  # execute the query
  results = db.query(sql)
  
  # sending to List widget, so map to :label and :value
  results.map do |row|
  	points.shift
  	points << {x: row['created_at'], y: row['temp_c']}
  end

  send_event('temperature', points: points)
end