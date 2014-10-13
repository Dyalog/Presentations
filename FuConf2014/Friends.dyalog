:Namespace Friends

      network←{             ⍝ random lists of friends for ⍵ people
          counts←?2*?⍵⍴⌊2⍟⍵ ⍝ Logarithmic distribution of # of friends
          (counts?¨⍵)~¨⍳⍵   ⍝ Deal "counts" fiends - but exclude self
      }
  
      distance←{                ⍝ distance between ⍺ and ⍵ for list of friends ⍺⍺
     
          dist←{
              ⍵[destination]:⍺  ⍝ We have arrived: return depth
              reached←⍵ ⋄ reached[∊reached/friends]←1  ⍝ Turn on next level of friends
              reached≡⍵:0       ⍝ No change: we can't get any further
              (⍺+1)∇ reached    ⍝ Try one more hop
          }
     
          (origin destination friends)←⍺ ⍵ ⍺⍺
          isfriend←(⍳≢friends)∊origin⊃friends  ⍝ 1 if each person is a friend else 0
          1 dist isfriend
      }
      
                                                                                  
      circle←{ ⍝ circle of friends: shortest distance from ⍵ to each person in friends list ⍺⍺ (0 means no path)
     
          circ←{
              reachable←∊(0≠hops←⍵)/friends      ⍝ people we can reach now
              new←(0=hops[reachable])/reachable  ⍝ previously unreachable
              hops[new]←⍺                        ⍝ mark with path length
              hops≡⍵:⍵                           ⍝ No change: we're done
              (⍺+1)∇ hops                        ⍝ Else we need one more hop
          }
     
          (origin friends)←⍵ ⍺⍺
          isfriend←(⍳≢friends)∊origin⊃friends  ⍝ 1 if each person is a friend else 0
          2 circ isfriend                      ⍝ Start searching for length 2 paths
      }
      
      path←{        ⍝ find path from ⍺ to ⍵ given friends list ⍺⍺
     
          onestep←{ ⍝ Complete one step backwards from destination
              (distance path)←⍺ ⍵
              i←(distances=distance)/⍳≢friends ⍝ people right distance away from origin
              next←∨/¨(1↑path)∊¨friends[i]     ⍝ with current head of path as a friend
              i[next⍳1],path                   ⍝ add new head of path
          }
     
          (origin destination friends)←⍺ ⍵ ⍺⍺
          distances←friends circle ⍺    ⍝ Calculate the circle
          distances[destination]=0:⍬    ⍝ No path
          origin,⊃onestep/(⍳¯1+destination⊃distances),destination
      }
                                                                                  
⍝Examples (should be expanded to Unit Tests :-))

    ∇ Test;n ⍝ Trace Me!
      n←≢F←,¨3 ⍬(1 4)⍬
      F circle 1
      F circle¨⍳n
      ↑F circle¨⍳n
      1(F distance)4
      2(F distance)2
      ∘.(F distance)⍨⍳n
      (↑F circle¨⍳n)≡∘.(F distance)⍨⍳n
     
      1 3 4≡1(F getpath)4
     
      F←make n←100
      42(F distance)97
      F circle 42
      (↑F circle¨⍳n)≡∘.(F distance)⍨⍳n
    ∇

:EndNamespace
