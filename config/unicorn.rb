#Set the working application directory
# working_directory "/path/to/your/app"
APP_NAME = "Team9Scholarships"
ROOT_PATH = "/home/rails_burse/#{APP_NAME}"

working_directory "#{ROOT_PATH}/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{ROOT_PATH}/pid/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "#{ROOT_PATH}/log/unicorn.log"
stdout_path "#{ROOT_PATH}/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.[#{APP_NAME}].sock"
listen "/tmp/unicorn.#{APP_NAME}.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30

