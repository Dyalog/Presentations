:Namespace DSL

    wikipedia←{#.HTTPTools.CachedGet'http://en.wikipedia.org/wiki/',⍵}
    of←{⍺ ⍵} ⍝ Syntactic glue
    firstWord←{(¯1+⌊/⍵⍳' ,/(')↑⍵}¨
        
      Columns←{
          (column table)←⍵
          1↓table[;table[1;]⍳column]
      }
      
    Column←{,Columns (,⊂1⊃⍵)(2⊃⍵)}
     
      Table←{
    ⍝ Extract ⍵'th table from XHTML as a matrix
    ⍝ Number of columns based on number of <th>'s found
    ⍝ If a <td> contains an <a> use the content from <a>
     
          data←⎕XML XHTML
          i←(+\data[;2]∊⊂'table')⍳⍵         ⍝ Position of nth table
          n←(i↓data[;1])((⍳∘0)>)data[i;1]   ⍝ Consecutive more deeply nested tags)
          t←data[i+⍳n;]                     ⍝ This is all data pertaining to our table
     
          i←{(⍵∊'td' 'th')/⍳≢⍵}t[;2]        ⍝ td or th
          cols←+/t[i;2]∊⊂'th'               ⍝ count the th's
          rows←(≢i)(⌊÷)cols                 ⍝ compute number of rows
          i←i+t[i+1;2]∊⊂,'a'                ⍝ use following row if it is <a>
          (rows cols)⍴t[i;3]                ⍝ reshape content into matrix
      }
 
:EndNamespace