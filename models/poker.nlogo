breed [cards card]
breed [players player]
cards-own [ value dealt? ]
players-own [ score ]
globals [win-loss-record me table]

to setup
  clear-all
  ask patches [set pcolor gray + 4]

  create-players num-players [
    setxy random-xcor random-ycor
    set shape "person"
    set color blue
  ]

  ask one-of players [
    set color green
    set me self
  ]

  reset-table
  set table (list table-1-value table-2-value table-3-value table-4-value table-5-value)

  set win-loss-record []

  reset-ticks
end

to reset-table
  ask cards [die]
  ask players [set score 0]
  let num 2
  create-cards 13 [ set shape "suit heart" set color red set value num set num num + 1]
  set num 2
  create-cards 13 [ set shape "suit diamond" set color red set value num set num num + 1]
  set num 2
  create-cards 13 [ set shape "suit spade" set color black set value num set num num + 1]
  set num 2
  create-cards 13 [ set shape "suit club" set color black set value num set num num + 1]

  ask cards [ set dealt? false set label value set label-color violet set size 1.5 ]

  ask cards with [value = card-1-value and shape = card-1-shape ] [
    create-links-with players with [color = green]
    set dealt? true
  ]

  ask cards with [value = card-2-value and shape = card-2-shape ] [
    create-links-with players with [color = green]
    set dealt? true
  ]

  ask players with [color = green] [
    move-near-me xcor ycor
  ]

  if table-1-value != 0 [
    ask cards with [value = table-1-value and shape = table-1-shape] [
      create-links-with players
      setxy -1 -3
      spread-out-card
      set dealt? true
    ]
  ]
  if table-2-value != 0 [
    ask cards with [value = table-2-value and shape = table-2-shape] [
      create-links-with players
      setxy -1 -3
      spread-out-card
      set dealt? true
    ]
  ]
  if table-3-value != 0 [
    ask cards with [value = table-3-value and shape = table-3-shape] [
      create-links-with players
      setxy -1 -3
      spread-out-card
      set dealt? true
    ]
  ]
  if table-4-value != 0 [
    ask cards with [value = table-4-value and shape = table-4-shape] [
      create-links-with players
      setxy -1 -3
      spread-out-card
      set dealt? true
    ]
  ]
  if table-5-value != 0 [
    ask cards with [value = table-5-value and shape = table-5-shape] [
      create-links-with players
      setxy -1 -3
      spread-out-card
      set dealt? true
    ]
  ]

end

to go
  reset-table
  play-poker
  plot-hist
  tick
end

to play-poker
  deal-cards
  deal-table
  ask players [ set score calculate-score ]

  ;; if i'm the player with the max score, add to my win record
  ifelse me = one-of players with [score = max [score] of players] [ set win-loss-record fput 1 win-loss-record ] [ set win-loss-record fput 0 win-loss-record ]
end

to plot-hist
  set-current-plot "Win Loss Record"
  set-plot-pen-mode 1
  histogram win-loss-record
  let maxbar modes win-loss-record
end

to-report calculate-score

  let value-card-list reverse sort-on [ value ] link-neighbors
  let shape-card-list sort-on [ shape ] link-neighbors

;  print-cards value-card-list

  let round-score -1

  set round-score royal-flush? value-card-list shape-card-list
  if round-score != -1 [report round-score + 450 ]

  set round-score straight-flush? value-card-list shape-card-list
  if round-score != -1 [report round-score + 400 ]

  set round-score four-of-a-kind? value-card-list
  if round-score != -1 [report round-score + 350 ]

  set round-score full-house? value-card-list
  if round-score != -1 [report round-score + 300 ]

  set round-score flush? value-card-list shape-card-list
  if round-score != -1 [report round-score + 250 ]

  set round-score straight? value-card-list
  if round-score != -1 [report round-score + 200 ]

  set round-score three-of-a-kind? value-card-list
  if round-score != -1 [report round-score + 150 ]

  set round-score two-pair? value-card-list
  if round-score != -1 [report round-score + 100 ]

  set round-score pair? value-card-list
  if round-score != -1 [ report round-score + 50 ]

  set round-score high-card? value-card-list
  report round-score

end

to-report high-card? [card-list]
  report [value] of item 0 card-list
end

to-report pair? [card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; returns -1 if there is no pair or the value of the highest pair
  let i 0
  repeat length card-list - 1 [
    let val [value] of item i card-list
    if val = [value] of item (i + 1) card-list [
      report val
    ]
    set i i + 1
  ]
  report -1
end

to-report two-pair? [card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; two-pair? calls pair? to check if there is one pair and then calls it again to check for a second pair.
  let first-pair pair? card-list
  if first-pair != -1 [
    ;; remove all instances of the first-pair and then check for a second pair.
    let second-pair pair? filter [ c -> [value] of c != first-pair ] card-list
    if second-pair != -1 [ report first-pair ]
  ]
  report -1
end

to-report three-of-a-kind? [card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; returns -1 if there is no 3oak or the value of the highest 3oak
  let i 0
  repeat length card-list - 2 [
    let val [value] of item i card-list
    if val = [value] of item (i + 1) card-list and val = [value] of item (i + 2) card-list [
      report val
    ]
    set i i + 1
  ]
  report -1
end

to-report straight? [card-list]
;; card-list is a reverse sorted list on the value of the card (sorted from greatest to least)
;;  how to consider A = 1?
;; returns -1 if five cards are not in consecutive order or the value of the highest set
  let i 1
  let len-of-straight 1
  let current-value [value] of item 0 card-list
  let beginning-of-straight current-value

  repeat length card-list - 1 [
    ifelse [value] of item i card-list = current-value - 1 [
      set current-value [value] of item i card-list
      set len-of-straight len-of-straight + 1
    ] [
      set current-value [value] of item i card-list
      set beginning-of-straight current-value
      set len-of-straight 1
    ]
    if len-of-straight >= 5 [
      report beginning-of-straight
    ]
    set i i + 1
  ]
  report -1
end

to-report flush? [value-card-list shape-card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; checks to see if the card-list is a flush
;; returns the highest number in that flush
  let flush-rank is-flush? shape-card-list
  if flush-rank != "z" [
    let value-card-filtered-list filter [c -> item 5 [shape] of c = flush-rank] value-card-list
    report [value] of item 0 value-card-filtered-list
  ]

  report -1
end

to-report is-flush? [card-list]
;; card-list is a list of the cards, organized by their shape (suit heart, suit diamond, ...) in the order of SHDC
;; grabs just the 5th letter of the shape and appends it to a list
;; counts the number of each SHDC to see if there IS a flush.
;; returns the letter of the flush

  let shape-list []
  foreach card-list [c ->
    set shape-list fput item 5 [shape] of c shape-list
  ]

  let num-hearts length filter [ s -> s = "h" ] shape-list
  let num-diamond length filter [ s -> s = "d" ] shape-list
  let num-club length filter [ s -> s = "c" ] shape-list
  let num-spade length filter [ s -> s = "s" ] shape-list

  if num-hearts >= 5 [ report "h" ]
  if num-diamond >= 5 [ report "d" ]
  if num-club >= 5 [ report "c" ]
  if num-spade >= 5 [ report "s" ]

  report "z"
end

to-report full-house? [card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; full-house calls three-of-a-kind? to check if there is a 3oak and then calls it again to check for a pair.
  let first-three three-of-a-kind? card-list
  if first-three != -1 [
    ;; remove all instances of the first-pair and then check for a second pair.
    let second-pair pair? filter [ c -> [value] of c != first-three] card-list
    if second-pair != -1 [ report first-three ]
  ]
  report -1
end

to-report four-of-a-kind? [card-list]
;; card-list is a reverse-sorted list on the value of the card (sorted from greatest to least)
;; returns -1 if there is no 4oak or the value of the highest 4oak
  let i 0
  repeat length card-list - 3 [
    let val [value] of item i card-list
    if val = [value] of item (i + 1) card-list and val = [value] of item (i + 2) card-list and val = [value] of item (i + 3) card-list [
      report val
    ]
    set i i + 1
  ]
  report -1
end

to-report straight-flush? [value-card-list shape-card-list]
;; checks to see if its a straight and if its a flush and if they start at the same place
;; return that value
  let flush-rank flush? value-card-list shape-card-list
  let straight-rank straight? value-card-list

  if flush-rank != -1 and flush-rank = straight-rank [
    report flush-rank
  ]
  report -1
end

to-report royal-flush? [ value-card-list shape-card-list ]
;; call straight flush and if it returns a 14 then you have a royal flush
  let sf-rank straight-flush? value-card-list shape-card-list
  if sf-rank = 14 [
    report 14
  ]
  report -1
end

to deal-cards
  ask players with [color != green] [
    let player-xcor xcor
    let player-ycor ycor
    repeat 2 [
      ;; pick one of the cards, set its status to dealt and then link it with a player
      let target one-of cards with [dealt? = false]
      ask target [ set dealt? true setxy player-xcor player-ycor spread-out-card]
      create-link-with target
    ]
  ]
end

to deal-table
  let table-xcor -1
  let table-ycor -3

  let available filter [c -> c > 1] table
  let num-on-table length available

  repeat 5 - num-on-table [
    let target one-of cards with [dealt? = false]
    ask target [
      setxy table-xcor table-ycor
      set dealt? true
      spread-out-card
      create-links-with players
    ]
  ]
end

to move-near-me [ my-xcor my-ycor ]
  ;; move the two cards near me
  ask link-neighbors [
    setxy my-xcor my-ycor
    spread-out-card
  ]
end

to spread-out-card
  left random 360
  right random 360
  forward 1
end

to print-cards [card-list]
  let print-list []
  foreach card-list [ c ->
    set print-list fput (word [value] of c item 5 [shape] of c) print-list
  ]
  show print-list
end

to-report chance-of-winning
  report sum win-loss-record / length win-loss-record * 100
end
@#$#@#$#@
GRAPHICS-WINDOW
281
72
712
504
-1
-1
12.82
1
20
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
29
81
92
114
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
20
133
120
193
num-players
3.0
1
0
Number

BUTTON
112
81
177
114
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
69
250
146
283
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
12
375
91
435
card-1-value
4.0
1
0
Number

INPUTBOX
14
455
92
515
card-2-value
5.0
1
0
Number

CHOOSER
102
455
240
500
card-2-shape
card-2-shape
"suit heart" "suit diamond" "suit club" "suit spade"
2

CHOOSER
101
383
239
428
card-1-shape
card-1-shape
"suit heart" "suit diamond" "suit club" "suit spade"
1

PLOT
776
314
1114
548
Win Loss Record
loss                                 win
times-won
0.0
2.0
0.0
100.0
true
false
"" ""
PENS
"hist" 1.0 0 -16777216 true "" ""

INPUTBOX
765
79
842
139
table-1-value
7.0
1
0
Number

CHOOSER
757
160
849
205
table-1-shape
table-1-shape
"suit heart" "suit diamond" "suit club" "suit spade"
3

CHOOSER
868
160
960
205
table-2-shape
table-2-shape
"suit heart" "suit diamond" "suit club" "suit spade"
3

CHOOSER
975
162
1067
207
table-3-shape
table-3-shape
"suit heart" "suit diamond" "suit club" "suit spade"
1

CHOOSER
1082
162
1174
207
table-4-shape
table-4-shape
"suit heart" "suit diamond" "suit club" "suit spade"
2

CHOOSER
1191
164
1283
209
table-5-shape
table-5-shape
"suit heart" "suit diamond" "suit club" "suit spade"
2

INPUTBOX
869
78
948
138
table-2-value
2.0
1
0
Number

INPUTBOX
979
80
1055
140
table-3-value
9.0
1
0
Number

INPUTBOX
1084
79
1159
139
table-4-value
4.0
1
0
Number

INPUTBOX
1192
80
1269
140
table-5-value
0.0
1
0
Number

MONITOR
1163
354
1309
415
NIL
chance-of-winning
2
1
15

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

suit club
false
0
Circle -7500403 true true 148 119 122
Circle -7500403 true true 30 119 122
Polygon -7500403 true true 134 137 135 253 121 273 105 284 195 284 180 273 165 253 159 138
Circle -7500403 true true 88 39 122

suit diamond
false
0
Polygon -7500403 true true 150 15 45 150 150 285 255 150

suit heart
false
0
Circle -7500403 true true 135 43 122
Circle -7500403 true true 43 43 122
Polygon -7500403 true true 255 120 240 150 210 180 180 210 150 240 146 135
Line -7500403 true 150 209 151 80
Polygon -7500403 true true 45 120 60 150 90 180 120 210 150 240 154 135

suit spade
false
0
Circle -7500403 true true 135 120 122
Polygon -7500403 true true 255 165 240 135 210 105 183 80 167 61 158 47 150 30 146 150
Circle -7500403 true true 43 120 122
Polygon -7500403 true true 45 165 60 135 90 105 117 80 133 61 142 47 150 30 154 150
Polygon -7500403 true true 135 210 135 253 121 273 105 284 195 284 180 273 165 253 165 210

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
