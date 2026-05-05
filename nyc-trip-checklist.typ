// NYC Trip Itinerary — May 6–13, 2026
#import "@preview/cetz:0.3.2": canvas, draw

#set page(
  paper: "a4",
  margin: (top: 1.8cm, bottom: 1.8cm, left: 1.8cm, right: 1.8cm),
  fill: rgb("#fafafa"),
  footer: context [
    #line(length: 100%, stroke: 0.4pt + rgb("#ccc"))
    #v(4pt)
    #text(size: 8pt, fill: rgb("#999"))[NYC Trip — May 6–13, 2026 #h(1fr) Page #counter(page).display()]
  ],
)

#set text(font: "Helvetica Neue", size: 9.5pt, fill: rgb("#2d2d2d"))
#set par(leading: 0.65em)

// --- Colors ---
#let accent = rgb("#1a5276")
#let green = rgb("#27ae60")
#let orange = rgb("#e67e22")
#let red = rgb("#c0392b")
#let lightblue = rgb("#d6eaf8")
#let lightgreen = rgb("#d5f5e3")
#let lightorange = rgb("#fdebd0")
#let lightred = rgb("#fadbd8")
#let verylightgray = rgb("#f7f9fc")

// Map palette
#let map-bg = rgb("#e8f4f8")
#let map-water = rgb("#b3d9e8")
#let map-land = rgb("#f5eedd")
#let map-park = rgb("#c8e6c0")
#let map-street = rgb("#e0d8cc")
#let map-pin = rgb("#e74c3c")
#let map-pin-home = rgb("#27ae60")
#let map-route = rgb("#e74c3c")
#let map-ferry = rgb("#3498db")

// --- Layout Helpers ---
#let section-title(icon, title) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (x: 14pt, y: 9pt),
    radius: 6pt,
    fill: accent,
    text(size: 13pt, weight: "bold", fill: white)[#icon #h(5pt) #title]
  )
  v(0.25em)
}

#let sub-heading(title) = {
  v(0.3em)
  text(size: 11pt, weight: "bold", fill: accent)[#title]
  v(0.15em)
}

#let tip-box(content-text) = {
  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: lightorange,
    stroke: 0.5pt + orange,
  )[
    #text(weight: "bold", fill: orange)[💡 Tip:] #h(3pt) #content-text
  ]
}

#let warn-box(content-text) = {
  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: lightred,
    stroke: 0.5pt + red,
  )[
    #text(weight: "bold", fill: red)[⚠] #h(3pt) #content-text
  ]
}

#let info-box(content-text) = {
  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: lightblue,
    stroke: 0.5pt + accent,
  )[#content-text]
}

#let day-header(date, title, subtitle) = {
  pagebreak(weak: true)
  block(
    width: 100%,
    inset: (x: 16pt, y: 14pt),
    radius: 8pt,
    fill: accent,
  )[
    #text(size: 20pt, weight: "bold", fill: white)[#date — #title]
    #v(2pt)
    #text(size: 10pt, fill: rgb("#b0cfe0"))[#subtitle]
  ]
  v(0.3em)
}

#let day-meta(anchor, pace) = {
  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: verylightgray,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      [#text(weight: "bold", size: 9pt)[🎯 Anchor:] #h(4pt) #anchor],
      [#text(weight: "bold", size: 9pt)[🏃 Pace:] #h(4pt) #pace],
    )
  ]
  v(0.2em)
}

#let sidebar-section(title, items) = {
  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: verylightgray,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[#title]
    #v(4pt)
    #for item in items {
      text(size: 9pt)[• #item] + linebreak()
    }
  ]
}

// ===================================================================
// MAP DRAWING SYSTEM — Tourist-friendly style
// ===================================================================

// Draw a pin-drop marker (teardrop shape)
#let draw-pin(pos, num, col: map-pin) = {
  let x = pos.at(0)
  let y = pos.at(1)
  // Drop shadow
  draw.circle((x + 1, y - 1), radius: 6.5, fill: rgb("#00000022"), stroke: none)
  // Pin body (circle)
  draw.circle(pos, radius: 7, fill: col, stroke: 1pt + white)
  // Number
  draw.content(pos, text(size: 6.5pt, weight: "bold", fill: white)[#num])
}

// Draw a label near a pin
#let draw-label(pos, label, anchor: "south", dx: 0, dy: -12) = {
  let lx = pos.at(0) + dx
  let ly = pos.at(1) + dy
  // Label background
  draw.content(
    (lx, ly),
    anchor: anchor,
    padding: 2pt,
    text(size: 6pt, weight: "bold", fill: rgb("#333"))[#label],
  )
}

// Draw a dashed route (ferry, return)
#let draw-dashed-route(..points) = {
  let pts = points.pos()
  for i in range(pts.len() - 1) {
    draw.line(pts.at(i), pts.at(i + 1), stroke: (paint: map-ferry, thickness: 1.8pt, dash: "dashed"))
  }
}

// Draw solid walking/subway route
#let draw-route(..points) = {
  let pts = points.pos()
  for i in range(pts.len() - 1) {
    draw.line(pts.at(i), pts.at(i + 1), stroke: (paint: map-route, thickness: 2pt))
  }
}

// Horizontal street lines for Manhattan grid feel
#let draw-manhattan-grid(x1, y1, x2, y2, count: 8) = {
  let h = y2 - y1
  let step = h / (count + 1)
  for i in range(1, count + 1) {
    let y = y1 + step * i
    draw.line((x1, y), (x2, y), stroke: 0.3pt + map-street)
  }
}

// Draw the NYC base map — tourist style
#let draw-tourist-base(w: 480, h: 200) = {
  // Background — light water
  draw.rect((0, 0), (w, h), fill: map-bg, stroke: 0.5pt + rgb("#c5dde6"), radius: 6pt)

  // Hudson River
  draw.rect((0, 0), (55, h), fill: map-water.lighten(20%), stroke: none, radius: (top-left: 6pt, bottom-left: 6pt))
  draw.content((27, h / 2 + 15), text(size: 6pt, fill: rgb("#6baed6"), style: "italic")[Hudson])
  draw.content((27, h / 2 - 2), text(size: 6pt, fill: rgb("#6baed6"), style: "italic")[River])

  // East River
  draw.rect((165, 0), (205, h), fill: map-water.lighten(20%), stroke: none)
  draw.content((185, h / 2 + 8), text(size: 6pt, fill: rgb("#6baed6"), style: "italic")[East])
  draw.content((185, h / 2 - 6), text(size: 6pt, fill: rgb("#6baed6"), style: "italic")[River])

  // Manhattan island shape (rounded, organic)
  draw.line(
    (65, h - 2), (72, h - 5), (80, h - 12), (88, h - 28),
    (95, h - 50), (100, h - 70), (105, h - 85),
    (110, h - 100), (115, h - 115), (120, h - 130),
    (128, h - 145), (135, h - 155), (140, h - 165),
    (145, h - 170), (150, h - 168), (155, h - 160),
    (153, h - 145), (148, h - 130), (143, h - 115),
    (138, h - 100), (133, h - 85), (128, h - 70),
    (125, h - 55), (120, h - 40), (115, h - 25),
    (108, h - 12), (100, h - 5), (90, h - 2),
    close: true,
    fill: map-land,
    stroke: 0.6pt + rgb("#c4b08b"),
  )

  // Manhattan grid lines
  draw-manhattan-grid(70, 8, 155, h - 8)

  // Central Park (green rectangle inside Manhattan)
  draw.rect((105, h - 55), (145, h - 25), fill: map-park, stroke: 0.4pt + rgb("#8fbc8f"), radius: 2pt)
  draw.content((125, h - 40), text(size: 5pt, fill: rgb("#3c763d"))[Central\ Park])

  // Manhattan label
  draw.content((110, h / 2 + 30), text(size: 7pt, fill: rgb("#8B7355"), style: "italic", weight: "bold")[Manhattan])

  // Queens
  draw.rect((210, 0), (w - 5, h * 0.55), fill: map-land.lighten(20%), stroke: 0.5pt + rgb("#c4b08b"), radius: 4pt)
  draw.content((340, h * 0.3), text(size: 8pt, fill: rgb("#8B7355"), style: "italic")[Queens])

  // Brooklyn
  draw.rect((210, h * 0.58), (w * 0.8, h - 5), fill: map-land.lighten(30%), stroke: 0.5pt + rgb("#c4b08b"), radius: 4pt)
  draw.content((300, h * 0.78), text(size: 8pt, fill: rgb("#8B7355"), style: "italic")[Brooklyn])
}

// Home pin with house emoji
#let draw-home-pin(pos) = {
  let x = pos.at(0)
  let y = pos.at(1)
  draw.circle((x + 1, y - 1), radius: 8, fill: rgb("#00000022"), stroke: none)
  draw.circle(pos, radius: 8, fill: map-pin-home, stroke: 1.5pt + white)
  draw.content(pos, text(size: 7pt, fill: white, weight: "bold")[H])
  draw.content((x, y + 14), anchor: "south", text(size: 5.5pt, fill: map-pin-home, weight: "bold")[Airbnb])
}

// Map legend
#let draw-legend(x, y) = {
  draw.circle((x, y), radius: 4, fill: map-pin, stroke: 0.5pt + white)
  draw.content((x + 10, y), anchor: "west", text(size: 5.5pt, fill: rgb("#666"))[Stop])
  draw.circle((x + 35, y), radius: 4, fill: map-pin-home, stroke: 0.5pt + white)
  draw.content((x + 45, y), anchor: "west", text(size: 5.5pt, fill: rgb("#666"))[Home])
  draw.line((x + 70, y), (x + 85, y), stroke: 2pt + map-route)
  draw.content((x + 90, y), anchor: "west", text(size: 5.5pt, fill: rgb("#666"))[Route])
}

// =============================================
// PAGE 1 — TITLE
// =============================================
#align(center)[
  #v(1.5cm)
  #text(size: 42pt, weight: "bold", fill: accent)[🗽 NYC Trip]
  #v(0.15cm)
  #text(size: 16pt, fill: rgb("#555"))[May 6 – 13, 2026]
  #v(0.1cm)
  #line(length: 50%, stroke: 1.5pt + accent)
  #v(0.8cm)
]

#info-box[
  #text(weight: "bold", size: 11pt)[🏠 Home Base — Flushing, Queens] #v(4pt)
  #text(size: 10pt)[
    *Address:* 43-55 Bowne St \#2, Flushing, NY 11355 \
    *Getting there:* Target Flushing–Main St station (7 Train), then short walk \
    *Design goal:* Relaxed pace, grouped neighborhoods, minimal backtracking
  ]
]

#v(0.6cm)

// --- Confirmed Reservations ---
#section-title("🎟️", "Confirmed Reservations")

#table(
  columns: (auto, 1fr, auto),
  align: (center, left, center),
  stroke: 0.4pt + rgb("#ddd"),
  fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { lightgreen.lighten(40%) } else { white },
  inset: 8pt,
  [*Date*], [*What*], [*Time*],
  [May 7], [American Museum of Natural History — Butterflies Event], [2:00 PM],
  [May 8], [Statue of Liberty ferry], [9:00 AM],
  [May 8], [9/11 Memorial Museum], [4:00 PM],
  [May 9], [Empire State Building (day + night return)], [10:00 AM / 8:30 PM],
  [May 10], [Harry Potter and the Cursed Child — Broadway], [7:00 PM],
  [May 11], [Top of the Rock], [6:50 PM],
)

// =============================================
// PRE-TRIP CHECKLIST — MOVED TO FRONT
// =============================================
#pagebreak(weak: true)
#section-title("✅", "Final Pre-Trip Checklist")

#text(size: 9.5pt, fill: rgb("#555"))[Print this page or tick it off on your phone before leaving.]

#v(0.3em)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[🛂 Documents]
    #v(4pt)
    #text(size: 9pt)[
      ☐ Current valid passport \
      ☐ Old passport with visa \
      ☐ Partner's passport \
      ☐ Partner's ESTA (PDF / screenshots) \
      ☐ Insurance policy saved offline
    ]
    #v(3pt)
    #text(size: 8pt, fill: orange)[⚠ You need BOTH passports!]
  ],

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[✈️ Flights]
    #v(4pt)
    #text(size: 9pt)[
      ☐ Outbound flight confirmation \
      ☐ Return flight confirmation \
      ☐ Airline app installed \
      ☐ Airport route saved (May 6 + return)
    ]
  ],

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[🏠 Airbnb]
    #v(4pt)
    #text(size: 9pt)[
      ☐ Address saved offline \
      ☐ Host contact saved \
      ☐ Check-in instructions noted \
      ☐ Door code / late arrival info
    ]
  ],

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[💳 Money]
    #v(4pt)
    #text(size: 9pt)[
      ☐ Main payment card \
      ☐ Backup payment card \
      ☐ Revolut / Wise (if used) \
      ☐ \$100–200 cash (USD)
    ]
  ],

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[📱 Phone & Tech]
    #v(4pt)
    #text(size: 9pt)[
      ☐ US plug adapter \
      ☐ Powerbank (charged!) \
      ☐ eSIM / roaming activated \
      ☐ Google Maps · Citymapper \
      ☐ Airline app · CityPASS app
    ]
  ],

  block(
    width: 100%,
    inset: 10pt,
    radius: 5pt,
    fill: white,
    stroke: 0.4pt + rgb("#ddd"),
  )[
    #text(weight: "bold", size: 10pt, fill: accent)[🧳 Packing]
    #v(4pt)
    #text(size: 9pt)[
      ☐ Comfortable walking shoes \
      ☐ Light jacket \
      ☐ Medicine / painkillers \
      ☐ Blister plasters \
      ☐ Sunglasses
    ]
    #v(3pt)
    #text(size: 8pt, fill: orange)[⚠ You'll walk 15k–25k steps/day!]
  ],
)

#v(0.5em)

// --- NYC Phone Folder ---
#grid(
  columns: (auto, 1fr),
  gutter: 12pt,
  align(horizon)[
    #block(
      inset: (x: 14pt, y: 9pt),
      radius: 6pt,
      fill: accent,
      text(size: 13pt, weight: "bold", fill: white)[📸 #h(5pt) NYC Phone Folder]
    )
  ],
  align(horizon)[
    #text(size: 9pt, fill: rgb("#666"))[Create one folder on your phone — screenshot everything below. Subway internet fails at the worst moment.]
  ],
)

#v(0.2em)

#table(
  columns: (auto, 1fr, auto, 1fr),
  align: (center, left, center, left),
  stroke: 0.4pt + rgb("#ddd"),
  fill: (_, row) => if calc.odd(row) { verylightgray } else { white },
  inset: 7pt,
  [*1*], [Outbound flight], [*6*], [Travel insurance],
  [*2*], [Return flight], [*7*], [Broadway tickets],
  [*3*], [Airbnb booking + address], [*8*], [CityPASS QR code],
  [*4*], [Passport photo pages], [*9*], [All CityPASS reservations],
  [*5*], [ESTA approval], [], [],
)

// =============================================
// MAY 6 — ARRIVAL
// =============================================
#day-header("May 6", "Arrival Day", "Land, check in, eat nearby, sleep early")

#day-meta("Arrival + Airbnb check-in", "Low effort — just get there safely")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [Arrival], [Land, collect bags, activate eSIM / roaming],
    [Transit], [Airport → Flushing–Main St → walk to Airbnb],
    [Evening], [Check in, unpack, eat nearby, sleep early],
  )

  #v(0.4em)
  #warn-box[You arrive at night — have the Airbnb address, door code, and check-in instructions saved *offline* before landing.]

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "Route depends on your airport",
    "Target: Flushing–Main St (7 Train)",
    "JFK → ~60–75 min; LGA/EWR check live",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Nan Xiang Xiao Long Bao",
    "Joe's Steam Rice Roll",
    "Shake Shack",
  ))

  #v(0.3em)
  #tip-box[Don't over-plan arrival night. Eat close, rest up — the real adventure starts tomorrow.]
]

// Map — May 6
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // Airport
    draw-pin((440, h - 20), "1")
    draw-label((440, h - 20), "Airport", anchor: "north", dy: 10)
    // Route
    draw-route((440, h - 20), (435, h * 0.55), (425, h * 0.42), (420, h * 0.35))
    // Legend
    draw-legend(10, h - 8)
    // Caption
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Verify exact airport route day-of — NYC airports differ a lot])
  })
]

// =============================================
// MAY 7 — AMNH + CENTRAL PARK + UES
// =============================================
#day-header("May 7", "AMNH + Central Park + UES", "Museum, butterflies, park walk, quick Upper East Side photo stop")

#day-meta("2:00 PM — AMNH Butterflies Event", "About 8–9 hours out · Moderate walking")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [8:45], [Leave Flushing],
    [10:00–1:30], [American Museum of Natural History — general visit],
    [1:30–2:00], [Snack / rest inside or nearby],
    [2:00–2:45], [Butterflies Special Event],
    [3:00–5:00], [Central Park: Bethesda Terrace, Bow Bridge, The Mall],
    [5:00–5:45], [Met Steps / UES — quick Gossip Girl-style photo stop],
    [Evening], [Dinner nearby, return to Flushing],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "Walk to Flushing–Main St",
    "7 Train → Times Sq–42 St",
    "Transfer B/C → 81 St–Museum of Natural History",
    "Allow ~50–60 min",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Levain Bakery",
    "Shake Shack",
    "Jacob's Pickles",
  ))

  #v(0.3em)
  #tip-box[AMNH is open daily 10:00 AM–5:30 PM. Keep the park route gentle after the museum — your legs will thank you.]
]

// Map — May 7
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // AMNH — west side of Central Park
    draw-pin((102, h - 28), "2")
    draw-label((102, h - 28), "AMNH", anchor: "east", dx: -12, dy: 0)
    // Central Park
    draw-pin((128, h - 40), "3")
    draw-label((128, h - 40), "Central Park", anchor: "west", dx: 12, dy: 0)
    // Met Steps / UES
    draw-pin((152, h - 35), "4")
    draw-label((152, h - 35), "Met / UES", anchor: "west", dx: 12, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (250, h * 0.5), (102, h - 28))
    draw-route((102, h - 28), (128, h - 40), (152, h - 35))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Upper West Side → Central Park → Upper East Side])
  })
]

// =============================================
// MAY 8 — STATUE OF LIBERTY + DOWNTOWN
// =============================================
#day-header("May 8", "Statue of Liberty + Downtown", "Ferry, Ellis Island, Wall Street, 9/11 Museum, bridge view")

#day-meta("9:00 AM Statue ferry · 4:00 PM 9/11 Museum", "Long day: ~10–11 hours · Start early")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [7:15], [Leave Flushing],
    [8:15–8:30], [Arrive Battery Park security area],
    [9:00], [Statue of Liberty ferry departs],
    [9:30–11:30], [Liberty Island + Statue Museum],
    [11:45–1:30], [Ellis Island Immigration Museum],
    [1:30–2:15], [Return ferry to Battery Park],
    [2:15–3:30], [Lunch + Wall Street / Federal Hall / Charging Bull],
    [4:00–5:45], [9/11 Memorial Museum visit],
    [6:00–7:00], [Brooklyn Bridge viewpoint or Seaport walk, then return],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "7 Train → Times Sq",
    "Transfer 1 Train → South Ferry",
    "Allow ~55–65 min",
    "Arrive 30 min before ferry for security",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Los Tacos No. 1",
    "Eataly Downtown",
    "Joe's Pizza",
  ))

  #v(0.3em)
  #warn-box[Bring ID, keep bags light for ferry security. The 9/11 Museum is emotionally heavy — keep the evening low-pressure.]
]

// Map — May 8
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // Battery Park
    draw-pin((85, h - 5), "2")
    draw-label((85, h - 5), "Battery Park", anchor: "west", dx: 12, dy: 3)
    // Liberty Island (in water)
    draw-pin((35, h - 15), "3")
    draw-label((35, h - 15), "Liberty Island", anchor: "north", dy: 12)
    // Ellis Island
    draw-pin((50, h - 35), "4")
    draw-label((50, h - 35), "Ellis Island", anchor: "east", dx: -12, dy: 0)
    // Wall Street
    draw-pin((110, h - 15), "5")
    draw-label((110, h - 15), "Wall St", anchor: "west", dx: 11, dy: 0)
    // 9/11 Museum
    draw-pin((100, h - 28), "6")
    draw-label((100, h - 28), "9/11 Museum", anchor: "west", dx: 11, dy: 0)
    // Brooklyn Bridge
    draw-pin((168, h - 40), "7")
    draw-label((168, h - 40), "Brooklyn Br.", anchor: "west", dx: 11, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (250, h * 0.6), (85, h - 5))
    draw-dashed-route((85, h - 5), (35, h - 15))
    draw-dashed-route((35, h - 15), (50, h - 35))
    draw-dashed-route((50, h - 35), (85, h - 5))
    draw-route((85, h - 5), (110, h - 15), (100, h - 28), (168, h - 40))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Ferry + Lower Manhattan loop · Dashed = ferry route])
  })
]

// =============================================
// MAY 9 — MIDTOWN + EMPIRE STATE
// =============================================
#day-header("May 9", "Midtown + Empire State", "Empire State daytime AND night views — both are part of the plan")

#day-meta("10:00 AM ESB day visit · Night return from 8:30 PM", "Full day: ~10–12 hours with rest breaks")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [9:00], [Leave Flushing],
    [10:00–11:30], [Empire State Building — daytime visit],
    [11:45–12:30], [Bryant Park + NY Public Library exterior],
    [12:30–1:15], [Grand Central Terminal],
    [1:15–2:30], [Lunch + 5th Ave / Rockefeller area],
    [2:30–3:15], [Times Square photo stop],
    [3:45–5:00], [Flatiron Building area + Madison Square Park],
    [5:00–8:15], [Dinner / rest / free time],
    [8:30–9:30], [Empire State Building — night visit],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "7 Train → Times Sq–42 St or Grand Central",
    "Allow ~35–45 min",
    "Walk between Midtown stops",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Chipotle",
    "Joe's Pizza",
    "The Hugh",
  ))

  #v(0.3em)
  #info-box[
    #text(weight: "bold")[ESB hours (May 9):] 10:00 AM–11:30 PM \
    Entry door closes 10:30 PM \
    Night return window starts *8:30 PM*
  ]
]

// Map — May 9
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // ESB
    draw-pin((115, h - 85), "2")
    draw-label((115, h - 85), "ESB", anchor: "east", dx: -11, dy: 0)
    // Bryant Park
    draw-pin((128, h - 70), "3")
    draw-label((128, h - 70), "Bryant Park", anchor: "west", dx: 11, dy: 0)
    // Grand Central
    draw-pin((140, h - 65), "4")
    draw-label((140, h - 65), "Grand Central", anchor: "west", dx: 11, dy: 0)
    // Times Square
    draw-pin((120, h - 65), "5")
    draw-label((120, h - 65), "Times Sq", anchor: "east", dx: -11, dy: 0)
    // Flatiron
    draw-pin((112, h - 100), "6")
    draw-label((112, h - 100), "Flatiron", anchor: "east", dx: -11, dy: 0)
    // ESB Night
    draw-pin((115, h - 85), "7", col: rgb("#9b59b6"))
    draw-label((115, h - 78), "Night ↩", anchor: "east", dx: -11, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (250, h * 0.45), (115, h - 85))
    draw-route((115, h - 85), (128, h - 70), (140, h - 65), (120, h - 65), (112, h - 100))
    draw.line((112, h - 100), (115, h - 85), stroke: (paint: rgb("#9b59b6"), thickness: 1.8pt, dash: "dashed"))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Midtown walking loop · Purple dashed = night return to ESB])
  })
]

// =============================================
// MAY 10 — SOHO + VILLAGE + BROADWAY
// =============================================
#day-header("May 10", "SoHo + Village + Broadway", "Slow neighborhood day before Harry Potter")

#day-meta("7:00 PM — Harry Potter on Broadway", "Relaxed day + show · Show ends ~9:55 PM")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [10:30], [Leave Flushing],
    [11:30–1:00], [SoHo walk — cast-iron streets, shopping, cafés],
    [1:00–2:00], [Lunch],
    [2:00–4:30], [Greenwich Village + Washington Square Park],
    [4:30–5:30], [West Village TV stops: Friends building + Carrie Bradshaw apt],
    [5:30–6:15], [Move toward Theater District + light dinner/snack],
    [6:20–6:30], [Arrive at Lyric Theatre],
    [7:00–9:55], [Harry Potter and the Cursed Child],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "7 Train → Times Sq / Grand Central",
    "Subway downtown for SoHo",
    "Allow ~40–50 min from Flushing",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Los Tacos No. 1",
    "Junior's Restaurant",
    "Joe Allen",
  ))

  #v(0.3em)
  #info-box[
    #text(weight: "bold")[🎭 Lyric Theatre:] 214 W 43rd St \
    Runtime: 2 hr 55 min including intermission
  ]
]

// Map — May 10
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // SoHo
    draw-pin((112, h - 120), "2")
    draw-label((112, h - 120), "SoHo", anchor: "west", dx: 11, dy: 0)
    // Greenwich Village
    draw-pin((105, h - 105), "3")
    draw-label((105, h - 105), "Village", anchor: "east", dx: -11, dy: 0)
    // Washington Sq
    draw-pin((110, h - 108), "4")
    draw-label((110, h - 115), "Wash. Sq", anchor: "east", dx: -35, dy: 6)
    // West Village
    draw-pin((95, h - 95), "5")
    draw-label((95, h - 95), "W. Village TV", anchor: "east", dx: -11, dy: 0)
    // Lyric Theatre
    draw-pin((120, h - 65), "6")
    draw-label((120, h - 65), "Lyric Theatre", anchor: "west", dx: 11, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (250, h * 0.5), (112, h - 120))
    draw-route((112, h - 120), (105, h - 105), (95, h - 95), (120, h - 65))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Downtown neighborhoods → Theater District])
  })
]

// =============================================
// MAY 11 — HIGH LINE + CHELSEA + TOP OF THE ROCK
// =============================================
#day-header("May 11", "High Line + Chelsea + Top of the Rock", "High Line, Chelsea Market, Little Island, then sunset views")

#day-meta("6:50 PM — Top of the Rock", "Full but smooth: ~9–10 hours out")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [10:30], [Leave Flushing],
    [11:15–12:00], [Hudson Yards / Vessel exterior photo stop],
    [12:00–1:15], [High Line walk from 30th St toward Chelsea],
    [1:15–2:30], [Chelsea Market lunch],
    [2:45–4:00], [Little Island + Hudson River walk],
    [4:00–5:30], [Coffee / rest + transfer to Rockefeller Center],
    [6:20], [Arrive at Top of the Rock entrance],
    [6:50–8:00], [Top of the Rock — sunset visit],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "7 Train direct → 34 St–Hudson Yards",
    "Walk the High Line / Chelsea area",
    "Subway or taxi to Rockefeller Center",
    "Arrive Top of the Rock by 6:20 PM",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Chelsea Market (many options inside!)",
    "Los Tacos No. 1",
    "Zou Zou's",
  ))

  #v(0.3em)
  #tip-box[Stay at Top of the Rock through sunset and into early city lights — the view changes completely.]
]

// Map — May 11
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // Hudson Yards
    draw-pin((82, h - 75), "2")
    draw-label((82, h - 75), "Hudson Yards", anchor: "east", dx: -11, dy: 0)
    // High Line
    draw-pin((80, h - 90), "3")
    draw-label((80, h - 90), "High Line", anchor: "east", dx: -11, dy: 0)
    // Chelsea Market
    draw-pin((78, h - 102), "4")
    draw-label((78, h - 102), "Chelsea Mkt", anchor: "east", dx: -11, dy: 0)
    // Little Island
    draw-pin((65, h - 110), "5")
    draw-label((65, h - 110), "Little Island", anchor: "east", dx: -11, dy: 0)
    // Top of the Rock
    draw-pin((130, h - 62), "6")
    draw-label((130, h - 62), "Top of the Rock", anchor: "west", dx: 11, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (250, h * 0.5), (82, h - 75))
    draw-route((82, h - 75), (80, h - 90), (78, h - 102), (65, h - 110))
    draw-route((65, h - 110), (130, h - 62))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[West Side walk south → subway up to Rockefeller sunset])
  })
]

// =============================================
// MAY 12 — BROOKLYN + MACY'S
// =============================================
#day-header("May 12", "Brooklyn Day + Macy's", "DUMBO, promenade, Williamsburg, then Herald Square shopping")

#day-meta("No fixed reservation — flexible day", "Full day: ~9–10 hours · Shopping included")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [10:00], [Leave Flushing],
    [11:00–12:30], [DUMBO waterfront + Manhattan Bridge photo spot],
    [12:30–1:30], [Lunch: Time Out Market or Juliana's area],
    [1:30–2:30], [Brooklyn Heights Promenade skyline walk],
    [2:30–3:15], [Travel to Williamsburg],
    [3:15–5:15], [Williamsburg cafés, local shops, vintage stores],
    [5:15–6:00], [Subway to 34 St–Herald Square],
    [6:00–7:30], [Macy's Herald Square shopping],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "7 Train → Grand Central → 4/5 → Borough Hall",
    "Or A/C → High St",
    "Allow ~55–65 min to DUMBO",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Time Out Market",
    "Juliana's Pizza",
    "Westville",
  ))

  #v(0.3em)
  #tip-box[This is the fullest day — keep lunch and rest breaks deliberate. If it feels too much, shorten Williamsburg to a quick coffee stop before Macy's.]
]

// Map — May 12
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // DUMBO
    draw-pin((215, h - 55), "2")
    draw-label((215, h - 55), "DUMBO", anchor: "west", dx: 11, dy: 0)
    // Brooklyn Heights
    draw-pin((220, h - 70), "3")
    draw-label((220, h - 70), "Bklyn Heights", anchor: "west", dx: 11, dy: 0)
    // Williamsburg
    draw-pin((240, h - 40), "4")
    draw-label((240, h - 40), "Williamsburg", anchor: "west", dx: 11, dy: 0)
    // Macy's
    draw-pin((118, h - 78), "5")
    draw-label((118, h - 78), "Macy's", anchor: "east", dx: -11, dy: 0)
    // Routes
    draw-route((420, h * 0.35), (300, h * 0.55), (215, h - 55))
    draw-route((215, h - 55), (220, h - 70))
    draw-route((220, h - 70), (240, h - 40))
    draw-route((240, h - 40), (200, h * 0.45), (118, h - 78))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Brooklyn route → subway to Herald Square for shopping])
  })
]

// =============================================
// MAY 13 — EASY QUEENS DAY
// =============================================
#day-header("May 13", "Easy Queens Day", "Low-stress final day near the Airbnb")

#day-meta("No reservation — pack and stay close", "Easy day: ~5–6 active hours")

#columns(2, gutter: 14pt)[
  #sub-heading("Timeline")
  #table(
    columns: (auto, 1fr),
    align: (left, left),
    stroke: 0.4pt + rgb("#ddd"),
    fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
    inset: 7pt,
    [*Time*], [*Plan*],
    [10:30–12:30], [Flushing Chinatown brunch / food crawl],
    [12:30–1:30], [Rest, pack, check documents],
    [2:00–4:30], [Flushing Meadows Corona Park + Unisphere],
    [5:00], [Early dinner back in Flushing],
    [Evening], [Pack, charge devices, save airport route],
  )

  #colbreak()

  #sidebar-section("🚇 Transport", (
    "Mostly walking or short local ride",
    "Everything stays close to Flushing",
    "Great buffer day for packing",
  ))

  #v(0.3em)

  #sidebar-section("🍜 Food Nearby", (
    "Nan Xiang Xiao Long Bao",
    "White Bear",
    "Joe's Steam Rice Roll",
  ))

  #v(0.3em)
  #warn-box[Confirm checkout time and airport route the night before. Charge everything!]
]

// Map — May 13
#v(0.3em)
#align(center)[
  #canvas(length: 1pt, {
    let h = 200
    draw-tourist-base(h: h)
    draw-home-pin((420, h * 0.35))
    // Flushing Chinatown
    draw-pin((400, h * 0.28), "2")
    draw-label((400, h * 0.28), "Chinatown", anchor: "east", dx: -11, dy: 0)
    // Flushing Meadows
    draw-pin((340, h * 0.42), "3")
    draw-label((340, h * 0.42), "Flushing Meadows", anchor: "west", dx: 11, dy: 0)
    // Routes — local loop
    draw-route((420, h * 0.35), (400, h * 0.28), (340, h * 0.42), (420, h * 0.35))
    draw-legend(10, h - 8)
    draw.content((240, h + 6), text(size: 7pt, fill: rgb("#999"), style: "italic")[Local Queens day — everything walking distance from home])
  })
]

// =============================================
// FLEXIBLE SWAPS
// =============================================
#pagebreak(weak: true)
#section-title("🔄", "Flexible Swaps")

#text(size: 9.5pt, fill: rgb("#555"))[All the best extras are already in the daily schedules. Use these swaps only if weather, energy, or mood calls for a change.]

#v(0.3em)

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  stroke: 0.4pt + rgb("#ddd"),
  fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
  inset: 8pt,
  [*If this happens…*], [*Do this instead*],
  [May 8 feels too heavy after 9/11 Museum], [Shorten the bridge walk → go straight to dinner],
  [May 11 is rainy], [Keep Chelsea Market + Top of the Rock, shorten Little Island / High Line],
  [May 12 feels too full], [Reduce Williamsburg to a coffee-and-shop stop before Macy's],
)

#v(0.6em)

// =============================================
// QUICK REFERENCE
// =============================================
#section-title("📋", "Quick Reference — Venue Hours")

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  stroke: 0.4pt + rgb("#ddd"),
  fill: (_, row) => if row == 0 { lightblue } else if calc.odd(row) { verylightgray } else { white },
  inset: 7pt,
  [*Venue*], [*Hours / Info*], [*Visit Time*],
  [AMNH], [Daily 10:00 AM–5:30 PM], [~3–4 hrs],
  [Statue of Liberty], [Arrive 30 min early for security; ferry loops Liberty + Ellis Island], [~5 hrs total],
  [9/11 Museum], [Wed–Mon 9 AM–7 PM, last entry 5:30 PM], [~1–1.5 hrs],
  [Empire State Building], [10 AM–11:30 PM; door closes 10:30 PM; night from 8:30 PM], [~1 hr each],
  [Top of the Rock], [Daily 8 AM–midnight, last entry 11:10 PM], [~45–60 min],
  [Harry Potter (Lyric)], [214 W 43rd St — May 10 at 7:00 PM], [2 hr 55 min],
  [Little Island], [6 AM–11 PM (Mar 8–May 24), weather permitting], [~1 hr],
  [Vessel], [11 AM–7 PM; tickets required], [~30 min],
)

// =============================================
// FOOTER
// =============================================
#v(1cm)
#align(center)[
  #block(
    width: 80%,
    inset: 14pt,
    radius: 8pt,
    fill: lightgreen,
    stroke: 0.5pt + green,
  )[
    #align(center)[
      #text(size: 12pt, weight: "bold", fill: accent)[Have an amazing trip! 🗽🍎]
      #v(3pt)
      #text(size: 9pt, fill: rgb("#555"))[
        Reservations and QR codes are more important than this PDF. \
        Use this for structure — use apps for live routing.
      ]
    ]
  ]
]
