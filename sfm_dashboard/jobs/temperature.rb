require 'mysql2'


# pulate the graph with some random points
points = []

10.downto(1) do |i|
  # mysql connection
  db = Mysql2::Client.new(host: "localhost", username: "root", password: "root", database: "sfm")

  # mysql query
  sql = "SELECT * FROM Data WHERE created_at < NOW() - INTERVAL " + i.to_s + " HOUR ORDER BY created_at DESC LIMIT 1"

  # execute the query
  results = db.query(sql)
  
  results.map do |row|
     points << {x: row['created_at'].to_time.strftime('%s').to_i, y: row['temp_c']}
     puts points
  end 

  db.close()
end

SCHEDULER.every '1h', :first_in => 0 do |job|

  points.shift
  
  # mysql connection
  db = Mysql2::Client.new(host: "localhost", username: "root", password: "root", database: "sfm")

  # mysql query
  sql = "SELECT * FROM Data ORDER BY created_at DESC LIMIT 1"

  # execute the query
  results = db.query(sql)
  
  db.close()
  
  # sending to List widget, so map to :label and :value
  results.map do |row|
	  points << {x: row['created_at'].to_time.strftime('%s').to_i, y: row['temp_c']}
	  #puts row['created_at'].to_time.strftime('%s')
  end
  
  send_event('temperature', points: points)
end
