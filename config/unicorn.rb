worker_processes 4

working_directory '/apps/application'

listen '/tmp/application.sock', backlog: 64

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

pid '/apps/application/shared/unicorn.pid'

stderr_path '/apps/application/log/unicorn-error.log'
