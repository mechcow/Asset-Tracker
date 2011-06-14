desc "Restart Passenger and enable debugging if DEBUG=true"
task :restart do
  system("touch tmp/restart.txt")
  system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
end
