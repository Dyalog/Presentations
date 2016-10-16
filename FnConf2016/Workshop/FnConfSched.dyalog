:Namespace FnConfSched

       fromJSON←7159⌶      ⍝ Convert JSON to APL object structure
      JSONnames←1∘(7162⌶) ⍝ Unmangle JSON names

      getNum←{⍺←⊣ ⋄ 2⊃⍺ ⎕VFI ⍵} ⍝ Convert text to Number using ⍺ as field separators
      fold←{lines←⌈(≢⍵)÷⍺ ⋄ lines ⍺⍴(lines×⍺)↑⍵} ⍝ Fold text into ⍺ columns
            
      Format←{
      ⍝ ⍵ is JSON representation of schedule
      ⍝ ⍺ is the day to be formatted
          
          ⍝ Extract sessions for the day as a list   
          sched←(fromJSON ⍵).conf_schedule.sessions[⍺] 
          sess←sched.(⍎¨⎕NL-2)                                                         
          eval←{⊃,/⍎'sess.',⍵} ⍝ Extract valua of variable for all sessions
          (timeslot track duration span title)←eval¨'timeslot' 'track' 'duration' 'track_span' 'title'
          track←4|'Track 1' 'Track 2' 'Track 3'⍳track ⍝ track# or 0 if none
          
          hhmm←(↑'- :'∘getNum¨timeslot)[;4 5]   ⍝ times in hours & minutes                 
          start←24 60⊥⍉hhmm                     ⍝ minutes since midnight
          starts←{⍵[⍋⍵]}∪start                  ⍝ unique start times, ascending
          output←((≢starts),⌈/track+span-1)⍴⊂'' ⍝ initialise output matrix
     
          row←starts⍳start                   ⍝ index into all observed timestamps
          col←∊(1⌈track)+¯1+⍳¨span           ⍝ extend each session to right according to span
     
          output[(span/row),¨col]←⊂'<---'    ⍝ insert "continuation" markers
          output[row,¨1⌈track]←20 fold¨title ⍝ fold and insert descriptions
     
          times←¯3↓¨¯8↑¨timeslot[start⍳starts]
          times,output      ⍝ formatted used time slots & sessions
      }

:EndNamespace
