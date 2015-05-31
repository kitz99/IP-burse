require 'finite-automaton'

m = FiniteAutomaton.new('a')
m.add_transition('a', 1, 'b')
m.add_transition('b', 0, 'a')
m.add_transition('a', 0, 'a')
m.add_transition('b', 1, 'b')
m.accept_states << 'b'
