directory '/root/nou2ube'
environment 'production'
daemonize true
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true
bind 'unix:///root/nou2ube/tmp/sockets/puma.sock'
