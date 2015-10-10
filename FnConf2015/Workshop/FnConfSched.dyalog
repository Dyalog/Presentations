:Namespace FnConfSched

      Format←{
      ⍝ ⍵ is JSON representation of schedule
      ⍝ ⍺ is the day to be formatted
     
          day←⍺ ⋄ JSON←⍵  ⍝ Name the arguments
     
          fromJSON←7159⌶  ⍝ Convert JSON to APL object structure
          fold←{lines←⌈(≢⍵)÷⍺ ⋄ lines ⍺⍴(lines×⍺)↑⍵} ⍝ Fold text into ⍺ columns
          eval←{⊃,/⍎'sessions.',⍵} ⍝ Extract valua of variable for all sessions
          getNum←{⊃2⊃⎕VFI ⍵}    ⍝ Convert text to Number
     
          sessions←(fromJSON JSON).conf_schedule.sessions[day].(⍎¨⎕NL-2) ⍝ Sessions as a list
     
          (timeslot track duration span title)←eval¨'timeslot' 'track' 'duration' 'track_span' 'title'
          duration←getNum¨duration       ⍝ Duration is formatted as text
          track←4|'Track 1' 'Track 2' 'Track 3'⍳track ⍝ track# or 0 if none
     
          start←24 60⊥⍉(↑2⊃¨'- :'∘⎕VFI¨timeslot)[;4 5] ⍝ minutes since midnight
          starts←{⍵[⍋⍵]}∪start           ⍝ unique start times, ascending
          output←((≢starts),⌈/track+span-1)⍴⊂''  ⍝ create output matrix
     
          row←starts⍳start                   ⍝ offset since start of day, in 5-minute intervals
          col←∊(1⌈track)+¯1+⍳¨span           ⍝ extend each session to right according to span
     
          output[(span/row),¨col]←⊂'<---'    ⍝ insert "continuation" markers
          output[row,¨1⌈track]←20 fold¨title ⍝ fold and insert descriptions
     
          times←¯3↓¨¯8↑¨timeslot[start⍳starts]
          times,output      ⍝ formatted used time slots & sessions
      }

:EndNamespace