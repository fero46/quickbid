require 'faye'

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run bayeux #use this instead of bayeux.listen(9292)