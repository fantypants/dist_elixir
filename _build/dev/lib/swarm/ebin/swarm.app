{application,swarm,
             [{description,"A fast, multi-master, distributed global process registry, with automatic distribution of worker processes."},
              {modules,['Elixir.Swarm','Elixir.Swarm.App',
                        'Elixir.Swarm.Entry','Elixir.Swarm.IntervalTreeClock',
                        'Elixir.Swarm.Logger','Elixir.Swarm.Registry',
                        'Elixir.Swarm.Tracker',
                        'Elixir.Swarm.Tracker.TrackerState',swarm]},
              {registered,[]},
              {vsn,"3.0.5"},
              {applications,[kernel,stdlib,elixir,logger,crypto,libring,
                             gen_state_machine]},
              {mod,{'Elixir.Swarm',[]}}]}.