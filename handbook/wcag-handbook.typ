// ──────────────────────────────────────────────
// WCAG · ARIA · Audyt dostępności — Mini-podręcznik
// Typst source · warm & approachable · purple palette
// ──────────────────────────────────────────────

// ── Color palette ──
#let purple-deep   = rgb("#5B21B6")   // headings, accents
#let purple-mid    = rgb("#7C3AED")   // secondary accent
#let purple-light  = rgb("#EDE9FE")   // backgrounds, highlights
#let purple-wash   = rgb("#F5F3FF")   // page tint for callouts
#let violet-soft   = rgb("#A78BFA")   // decorative
#let warm-coral    = rgb("#F87171")   // warnings, errors
#let warm-amber    = rgb("#FBBF24")   // tips
#let warm-green    = rgb("#34D399")   // success / good examples
#let text-dark     = rgb("#1E1B4B")   // body text
#let text-mid      = rgb("#4C1D95")   // sub-headings
#let gray-soft     = rgb("#F9FAFB")   // table alt rows
#let gray-border   = rgb("#E5E7EB")   // borders

// ── Page setup ──
#set page(
  paper: "a4",
  margin: (top: 2.8cm, bottom: 2.4cm, left: 2.4cm, right: 2.4cm),
  header: context {
    if counter(page).get().first() > 1 {
      set text(8pt, fill: purple-mid)
      [WCAG · audyt dostępności]
      h(1fr)
      counter(page).display()
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      set text(7pt, fill: gray-border)
      line(length: 100%, stroke: 0.3pt + gray-border)
    }
  },
)

// ── Typography ──
#set text(
  font: "Helvetica Neue",
  fallback: true,
  size: 10pt,
  fill: text-dark,
  lang: "pl",
)

#set par(
  leading: 0.72em,
  justify: true,
)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(1.2cm)
  block(
    below: 0.8cm,
    text(22pt, weight: "bold", fill: purple-deep, it.body)
  )
  v(0.1cm)
  line(length: 40%, stroke: 2.5pt + violet-soft)
  v(0.4cm)
}

#show heading.where(level: 2): it => {
  v(0.6cm)
  block(
    below: 0.4cm,
    text(15pt, weight: "bold", fill: text-mid, it.body)
  )
}

#show heading.where(level: 3): it => {
  v(0.4cm)
  block(
    below: 0.3cm,
    text(12pt, weight: "bold", fill: purple-mid, it.body)
  )
}

// ── Reusable components ──

// Callout / admonition box
#let callout(title: none, icon: "💡", accent: purple-mid, body) = {
  v(0.3cm)
  block(
    width: 100%,
    radius: 8pt,
    fill: purple-wash,
    stroke: (left: 4pt + accent),
    breakable: false,
    inset: (x: 16pt, y: 12pt),
    [
      #if title != none {
        text(weight: "bold", size: 10pt, fill: accent, [#icon #title])
        v(4pt)
      }
      #set text(size: 9.5pt)
      #body
    ]
  )
  v(0.3cm)
}

// Warning callout
#let warning(title: "Pułapka", body) = callout(
  title: title,
  icon: "⚠️",
  accent: warm-coral,
  body,
)

// Tip callout
#let tip(title: "Wskazówka", body) = callout(
  title: title,
  icon: "✨",
  accent: warm-amber,
  body,
)

// Good practice callout
#let good(title: "Dobra praktyka", body) = callout(
  title: title,
  icon: "✅",
  accent: warm-green,
  body,
)

// Exam note callout
#let exam(title: "Myśl egzaminacyjna", body) = callout(
  title: title,
  icon: "🎓",
  accent: purple-deep,
  body,
)

// Key formula / highlighted box
#let keybox(body) = {
  v(0.3cm)
  block(
    width: 100%,
    radius: 12pt,
    fill: purple-light,
    inset: (x: 20pt, y: 16pt),
    stroke: 1pt + violet-soft,
    breakable: false,
    [
      #set text(size: 11pt, weight: "medium", fill: purple-deep)
      #body
    ]
  )
  v(0.3cm)
}

// Nice table
#let styled-table(columns: auto, header: (), ..rows) = {
  v(0.2cm)
  table(
    columns: columns,
    fill: (_, y) => if y == 0 { purple-light } else if calc.odd(y) { gray-soft } else { white },
    stroke: 0.5pt + gray-border,
    inset: (x: 10pt, y: 8pt),
    align: left,
    ..header.map(h => [*#h*]),
    ..rows.pos().flatten(),
  )
  v(0.2cm)
}

// Unchecked checkbox
#let checkbox = box(
  width: 9pt,
  height: 9pt,
  radius: 2pt,
  stroke: 0.8pt + purple-mid,
  fill: white,
  inset: 0pt,
)

// Tag / pill
#let tag(label, color: purple-mid) = {
  box(
    radius: 4pt,
    fill: color.lighten(80%),
    inset: (x: 8pt, y: 3pt),
    text(8pt, weight: "medium", fill: color, label)
  )
}


// ╔══════════════════════════════════════════╗
// ║            COVER PAGE                    ║
// ╚══════════════════════════════════════════╝
#page(
  margin: 0pt,
  header: none,
  footer: none,
)[
  #block(
    width: 100%,
    height: 100%,
    fill: gradient.linear(purple-deep, rgb("#3B0764"), angle: 135deg),
  )[
    // Decorative circles
    #place(top + right, dx: -1cm, dy: 1.5cm,
      circle(radius: 4cm, fill: purple-mid.transparentize(70%))
    )
    #place(top + right, dx: 1cm, dy: -1cm,
      circle(radius: 2.5cm, fill: violet-soft.transparentize(80%))
    )
    #place(bottom + left, dx: -2cm, dy: -3cm,
      circle(radius: 5cm, fill: purple-mid.transparentize(85%))
    )
    #place(bottom + right, dx: 0cm, dy: -1cm,
      circle(radius: 1.8cm, fill: warm-amber.transparentize(75%))
    )

    // Content
    #pad(x: 3cm, top: 5cm)[
      #text(11pt, tracking: 3pt, fill: violet-soft, weight: "medium")[WCAG · ARIA · AUDYT DOSTĘPNOŚCI]
      #v(1.5cm)
      #text(38pt, weight: "bold", fill: white)[Mini-podręcznik\ do nauki egzaminu]
      #v(1cm)
      #text(13pt, fill: rgb("#C4B5FD"), weight: "regular")[
        Praktyczne notatki, przykłady błędów, checklisty,\
        tabele i fiszki dla osób uczących się audytowania\
        stron internetowych zgodnie z WCAG.
      ]
      #v(3cm)
      #block(
        radius: 12pt,
        fill: white.transparentize(90%),
        inset: (x: 20pt, y: 14pt),
        stroke: 1pt + white.transparentize(70%),
      )[
        #text(10pt, fill: rgb("#DDD6FE"), weight: "medium")[
          💡 *Jak korzystać?* Najpierw przeczytaj rozdziały 1–8, potem przejdź przez kryteria WCAG, checklisty i fiszki.
        ]
      ]
      #v(1fr)
      #text(8pt, fill: rgb("#A78BFA"))[Opracowanie edukacyjne · wersja nowoczesna · 26 kwietnia 2026]
      #v(1.5cm)
    ]
  ]
]


// ╔══════════════════════════════════════════╗
// ║         TABLE OF CONTENTS                ║
// ╚══════════════════════════════════════════╝

#page(header: none)[
  #v(1.5cm)
  #text(11pt, tracking: 2pt, fill: purple-mid, weight: "medium")[PODRĘCZNIK]
  #v(0.4cm)
  #text(26pt, weight: "bold", fill: purple-deep)[Jak korzystać]
  #v(0.3cm)
  #line(length: 30%, stroke: 2pt + violet-soft)
  #v(0.6cm)
  #text(10.5pt, fill: text-dark)[
    Ten mini-podręcznik jest skrótem do nauki. Nie zastępuje pełnego standardu WCAG ani dokumentacji WAI-ARIA, ale pomaga szybko zrozumieć najważniejsze zasady i ćwiczyć myślenie audytorskie.
  ]
  #v(0.4cm)

  #keybox[
    Dostępna strona to taka, którą można *zauważyć*, *obsłużyć*, *zrozumieć* i *poprawnie odczytać* za pomocą różnych technologii.
  ]

  #v(0.6cm)
  #text(18pt, weight: "bold", fill: purple-deep)[Spis treści]
  #v(0.3cm)

  #let toc-entry(num, title) = {
    block(
      below: 4pt,
      inset: (y: 3pt),
      [
        #box(
          width: 28pt,
          radius: 6pt,
          fill: purple-light,
          inset: (x: 6pt, y: 3pt),
          align(center, text(9pt, weight: "bold", fill: purple-deep, num))
        )
        #h(10pt)
        #text(10.5pt, fill: text-dark, title)
      ]
    )
  }

  #toc-entry("1", "Mapa pojęć: WCAG, poziomy i POUR")
  #toc-entry("2", "Postrzegalność")
  #toc-entry("3", "Funkcjonalność")
  #toc-entry("4", "Zrozumiałość")
  #toc-entry("5", "Solidność i kompatybilność")
  #toc-entry("6", "Treści nietekstowe i multimedia")
  #toc-entry("7", "ARIA, linki i komponenty interaktywne")
  #toc-entry("8", "Audyt: jak opisywać błędy")
  #toc-entry("9", "Rozdział powtórkowy: kryteria WCAG 2.1/2.2")
  #toc-entry("10", "Checklisty egzaminacyjne")
  #toc-entry("11", "Fiszki i plan powtórki")
  #toc-entry("12", "Kontekst prawny i przyszłość WCAG")
  #v(4pt)
  #text(9pt, fill: purple-mid, style: "italic")[Źródła]
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 1 — MAPA POJĘĆ              ║
// ╚══════════════════════════════════════════╝

= 1. Mapa pojęć: WCAG, poziomy i POUR

WCAG, czyli Web Content Accessibility Guidelines, to wytyczne tworzenia dostępnych treści internetowych. W praktyce pomagają odpowiedzieć na pytanie: _czy z danej strony może skorzystać osoba, która nie widzi, nie słyszy, nie używa myszy, potrzebuje prostszego języka albo korzysta z technologii asystującej?_

== Struktura WCAG

#styled-table(
  columns: (1.2fr, 2fr, 2fr),
  header: ("Element", "Co oznacza?", "Przykład"),
  [Zasada], [Najwyższy poziom organizacji wytycznych.], [Postrzegalność, Funkcjonalność, Zrozumiałość, Solidność.],
  [Wytyczna], [Obszar, który rozwija zasadę.], [1.1 Alternatywa tekstowa.],
  [Kryterium sukcesu], [Testowalny wymóg, który można spełnić albo naruszyć.], [1.1.1 Treść nietekstowa.],
  [Techniki i błędy], [Przykłady wdrożeń i znane niepoprawne rozwiązania.], [Atrybut alt, etykiety formularzy, obsługa klawiatury.],
)

== Poziomy zgodności

#styled-table(
  columns: (0.6fr, 3fr),
  header: ("Poziom", "Znaczenie praktyczne"),
  [A], [Minimum. Brak spełnienia często blokuje korzystanie ze strony.],
  [AA], [Najczęstszy poziom wymagany w praktyce i w wielu regulacjach.],
  [AAA], [Najwyższy poziom. Często traktowany jako cel dla wybranych treści, nie całych serwisów.],
)

== POUR w jednym zdaniu

#block(breakable: false)[
#styled-table(
  columns: (0.4fr, 1.2fr, 2fr),
  header: ("Litera", "Zasada", "Pytanie kontrolne"),
  [*P*], [Perceivable — Postrzegalność], [Czy użytkownik może odebrać treść?],
  [*O*], [Operable — Funkcjonalność], [Czy użytkownik może obsłużyć interfejs?],
  [*U*], [Understandable — Zrozumiałość], [Czy użytkownik rozumie treść i działanie?],
  [*R*], [Robust — Solidność], [Czy treść działa z różnymi technologiami, w tym asystującymi?],
)
]

#exam[
  Na egzaminie nie ucz się WCAG jak listy numerów. Ucz się rozpoznawać *barierę*, jej *wpływ na użytkownika* i właściwą *rekomendację naprawy*.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 2 — POSTRZEGALNOŚĆ           ║
// ╚══════════════════════════════════════════╝

= 2. Postrzegalność

Postrzegalność oznacza, że informacje i komponenty interfejsu muszą być przedstawione tak, aby użytkownik mógł je odebrać. Nie chodzi tylko o wzrok — treść może być odebrana przez słuch, dotyk, mowę syntetyczną, brajl albo inną formę.

#h(4pt)
#tag("obrazy") #h(4pt) #tag("kontrast") #h(4pt) #tag("multimedia") #h(4pt) #tag("struktura")

== Co sprawdzać?

*Teksty alternatywne.* Obraz informacyjny powinien mieć alternatywę tekstową. Obraz dekoracyjny powinien być możliwy do pominięcia przez technologie asystujące, np. przez `alt=""`.

*Kontrast i kolor.* Tekst, ikony, obramowania pól i stany interfejsu muszą być widoczne. Informacja nie może zależeć wyłącznie od koloru.

*Multimedia.* Audio, wideo i transmisje wymagają odpowiednich alternatyw: napisów rozszerzonych, transkrypcji i audiodeskrypcji.

*Struktura treści.* Nagłówki, listy i tabele powinny być oznaczone semantycznie, aby czytnik ekranu mógł odtworzyć strukturę.

== Typowe błędy

- Obraz z ważną informacją ma pusty `alt` albo brak atrybutu `alt`.
- Ikona koszyka jest przyciskiem, ale nie ma nazwy dostępnej.
- Wykres nie ma tabeli danych ani opisu.
- Komunikat błędu formularza jest pokazany tylko czerwonym kolorem.
- Tekst ma zbyt niski kontrast względem tła.
- Film ma napisy, ale nie ma audiodeskrypcji, mimo że obraz niesie ważną treść.

#callout(title: "Myśl audytorska", icon: "🔍", accent: purple-deep)[
  Zapytaj: _„Co straci osoba, która nie widzi obrazu, nie słyszy dźwięku albo nie rozróżnia koloru?"_. Jeżeli traci sens informacji, potrzebna jest alternatywa.
]

== Przykład opisu problemu

#block(
  width: 100%,
  radius: 8pt,
  inset: (x: 16pt, y: 12pt),
  fill: gray-soft,
  stroke: 0.5pt + gray-border,
)[
  *Problem:* Infografika przedstawia harmonogram rekrutacji, ale obraz nie ma tekstowej alternatywy.\
  *Wpływ:* osoba korzystająca z czytnika ekranu nie pozna dat ani etapów.\
  *Rekomendacja:* dodać opis tekstowy z etapami i datami albo tabelę z tymi samymi informacjami.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 3 — FUNKCJONALNOŚĆ           ║
// ╚══════════════════════════════════════════╝

= 3. Funkcjonalność

Funkcjonalność oznacza, że użytkownik musi móc obsłużyć stronę. Kluczowe pytanie: _czy wszystko, co można zrobić myszą, da się zrobić także klawiaturą lub technologią asystującą?_

== Test klawiatury

#styled-table(
  columns: (1fr, 2fr, 2fr),
  header: ("Klawisz", "Co powinien umożliwiać?", "Co może być błędem?"),
  [Tab], [Przejście do kolejnego elementu interaktywnego.], [Fokus omija przycisk, link albo pole formularza.],
  [Shift + Tab], [Powrót do poprzedniego elementu.], [Fokus wraca w nielogiczne miejsce.],
  [Enter], [Aktywacja linku lub przycisku.], [Link zrobiony ze `span` nie reaguje.],
  [Space], [Aktywacja przycisku, checkboxa, przełącznika.], [Fałszywy przycisk działa tylko kliknięciem myszy.],
  [Esc], [Zamknięcie modala, menu lub wyskakującej warstwy.], [Użytkownik zostaje uwięziony w oknie.],
)

== Najważniejsze kryteria do skojarzenia

*2.1.1 Klawiatura.* Funkcje powinny być dostępne z klawiatury, chyba że wymagają ścieżki ruchu zależnej od użytkownika.

*2.1.2 Bez pułapki.* Jeżeli fokus wejdzie do komponentu, użytkownik musi móc go opuścić klawiaturą.

*2.4.3 Kolejność fokusu.* Kolejność przechodzenia musi zachowywać sens i funkcjonalność.

*2.4.7 Widoczny fokus.* Użytkownik musi widzieć, który element jest aktualnie aktywny.

== Typowe błędy

- Menu otwiera się tylko po najechaniu myszą.
- Modal nie zatrzymuje fokusu albo nie da się go zamknąć klawiaturą.
- Fokus jest usunięty przez CSS, np. `outline: none`, bez alternatywy.
- Automatyczny slider nie ma pauzy.
- Linki „więcej", „tutaj", „czytaj" nie mówią, dokąd prowadzą.

#warning(title: "Pułapka egzaminacyjna")[
  Samo ustawienie `tabindex="0"` nie wystarcza. Element musi mieć także właściwą *rolę*, *nazwę*, *stan* i *obsługę klawiatury* zgodną z oczekiwanym zachowaniem.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 4 — ZROZUMIAŁOŚĆ             ║
// ╚══════════════════════════════════════════╝

= 4. Zrozumiałość

Zrozumiałość oznacza, że użytkownik powinien rozumieć treść, nawigację, formularze, błędy i konsekwencje swoich działań. Strona ma być przewidywalna.

== Co sprawdzać?

*Język strony.* Dokument powinien mieć poprawny język, np. `<html lang="pl">`. Fragmenty w innym języku też powinny być oznaczone.

*Spójność.* Nawigacja i powtarzalne komponenty powinny działać i nazywać się konsekwentnie.

*Formularze.* Pola potrzebują etykiet i instrukcji. Komunikaty błędów powinny wskazywać, co naprawić.

*Przewidywalność.* Zmiana fokusu albo wpisanie danych nie powinny nagle przenosić użytkownika bez ostrzeżenia.

== Formularz: najczęstsze problemy

#styled-table(
  columns: (1.2fr, 1.5fr, 1.5fr),
  header: ("Problem", "Dlaczego to bariera?", "Lepsze rozwiązanie"),
  [Pole bez etykiety.], [Czytnik ekranu nie ogłosi, czego dotyczy pole.], [Użyć `label` albo równoważnej nazwy dostępnej.],
  [Błąd tylko kolorem.], [Nie wszyscy rozróżnią kolor; czytnik może nie odczytać problemu.], [Dodać tekstowy komunikat i powiązać go z polem.],
  [Komunikat „Nieprawidłowe dane".], [Użytkownik nie wie, jak poprawić błąd.], [Napisać konkretnie: „Wpisz adres e-mail w formacie nazwa\@example.com".],
  [Przycisk „Wyślij" bez informacji o skutku.], [Nie wiadomo, czy nastąpi zakup, zapis, wysłanie formularza czy płatność.], [Użyć nazwy opisującej akcję, np. „Zapisz zgłoszenie".],
)

#callout(title: "Do zapamiętania", icon: "📌")[
  Zrozumiałość nie oznacza tylko prostego języka. Obejmuje też *przewidywalne zachowanie interfejsu* i *jasną pomoc przy błędach*.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 5 — SOLIDNOŚĆ                ║
// ╚══════════════════════════════════════════╝

= 5. Solidność i kompatybilność

Solidność oznacza, że strona powinna być zbudowana tak, aby różne przeglądarki, czytniki ekranu i inne technologie mogły poprawnie zinterpretować strukturę i komponenty.

== Semantyczny HTML to podstawa

Najlepszą dostępność często daje proste, poprawne HTML. Przycisk powinien być przyciskiem, link linkiem, nagłówek nagłówkiem, a pole formularza polem z etykietą. Gdy używamy elementów niezgodnie z przeznaczeniem, musimy samodzielnie odtworzyć zachowanie, role i komunikację z technologiami asystującymi.

#styled-table(
  columns: (1fr, 1fr),
  header: ("✅ Dobrze", "⚠️ Ryzykownie"),
  [`<button type="button">Otwórz menu</button>`], [`<div role="button" tabindex="0">Otwórz menu</div>`],
)

== 4.1.2 Nazwa, rola, wartość

To jedno z najważniejszych kryteriów dla komponentów interfejsu. Użytkownik technologii asystującej musi wiedzieć: *czym jest* element, *jak się nazywa*, jaki ma *stan* i jaką *wartość*.

#styled-table(
  columns: (0.8fr, 1.5fr, 2fr),
  header: ("Pojęcie", "Przykład", "Błąd"),
  [Nazwa], [„Koszyk", „Zamknij okno", „Szukaj".], [Przycisk ikonowy bez etykiety.],
  [Rola], [`button`, `link`, `checkbox`, `heading`.], [Element wygląda jak przycisk, ale jest zwykłym `div`.],
  [Stan], [Rozwinięte/zwinięte, zaznaczone/niezaznaczone.], [Menu ma `aria-expanded`, ale wartość się nie zmienia.],
  [Wartość], [Poziom suwaka, liczba, stan pola.], [Suwak nie przekazuje aktualnej wartości.],
)

#good(title: "Najkrótsza rada techniczna")[
  Jeżeli HTML ma natywny element do danej funkcji — *użyj go*. ARIA jest wsparciem, nie magiczną naprawą złej struktury.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 6 — MULTIMEDIA               ║
// ╚══════════════════════════════════════════╝

= 6. Treści nietekstowe i multimedia

Treści nietekstowe to obrazy, ikony, wykresy, kontrolki graficzne, audio, wideo, CAPTCHA i inne elementy, których znaczenie nie jest zapisane jako zwykły tekst. Kryterium 1.1.1 wymaga tekstowej alternatywy pełniącej tę samą funkcję.

== 1.1.1 Treść nietekstowa

#styled-table(
  columns: (1fr, 1.8fr, 1.8fr),
  header: ("Typ treści", "Co zwykle zrobić?", "Ważna uwaga"),
  [Obraz informacyjny], [Dodać krótki, sensowny `alt`.], [Alt zależy od kontekstu, nie tylko od wyglądu obrazka.],
  [Obraz dekoracyjny], [Użyć `alt=""` albo ukryć przed technologiami asystującymi.], [Nie zmuszaj czytnika do czytania ozdobników.],
  [Wykres], [Dodać opis trendu i dane w tabeli.], [Krótki `alt` zwykle nie wystarczy.],
  [Ikona jako przycisk], [Zapewnić nazwę dostępną.], [Ikona lupy bez nazwy może być odczytana niejasno.],
  [CAPTCHA], [Zapewnić alternatywne metody weryfikacji.], [Jedna metoda może wykluczać część użytkowników.],
)

== Multimedia: kto czego potrzebuje?

W multimediach obowiązuje kluczowa zasada: _jedna forma alternatywy nie wystarcza wszystkim grupom użytkowników_. Osoby z dysfunkcją wzroku potrzebują audiodeskrypcji lub transkrypcji, osoby z dysfunkcją słuchu napisów rozszerzonych, a osoby głuchoniewidome szczególnie transkrypcji rozszerzonej.

#styled-table(
  columns: (1.3fr, 1.3fr, 1.5fr),
  header: ("Grupa użytkowników", "Potrzebna alternatywa", "Po co?"),
  [Osoby niewidome i słabowidzące], [Audiodeskrypcja, transkrypcja.], [Żeby poznać istotne informacje wizualne.],
  [Osoby głuche i niedosłyszące], [Napisy rozszerzone, transkrypcja.], [Żeby poznać wypowiedzi i ważne dźwięki.],
  [Osoby głuchoniewidome], [Transkrypcja rozszerzona.], [Żeby otrzymać treść audio i wizualną w tekście możliwym do przetworzenia.],
)

== Napisy rozszerzone

Napisy rozszerzone to nie są zwykłe napisy dialogowe. Powinny przekazywać dialogi, identyfikację mówiących, istotne efekty dźwiękowe, muzykę i inne informacje audio potrzebne do zrozumienia materiału.

#styled-table(
  columns: (1fr, 1.5fr),
  header: ("Zwykłe napisy", "Napisy rozszerzone"),
  [„Zaczynamy spotkanie."], [„\[spokojna muzyka\] Anna: Zaczynamy spotkanie. \[dzwonek telefonu\]"],
)

=== Napisy rozszerzone: otwarte i zamknięte

„Rozszerzone" mówi o treści napisów, a „otwarte" i „zamknięte" mówią o sposobie ich dostarczenia. Napisy rozszerzone mogą być zarówno otwarte, jak i zamknięte.

#styled-table(
  columns: (1fr, 1.5fr, 2fr),
  header: ("Rodzaj", "Co to znaczy?", "Plusy i ograniczenia"),
  [Otwarte (open captions)], [Napisy są wbudowane na stałe w obraz i nie da się ich wyłączyć.], [Działają nawet tam, gdzie platforma nie obsługuje osobnych ścieżek. Minusem jest brak personalizacji i ryzyko zasłonięcia ważnej treści.],
  [Zamknięte (closed captions)], [Napisy są osobną ścieżką tekstową, którą użytkownik może włączyć lub wyłączyć.], [Są zwykle lepsze dostępnościowo, bo pozwalają na wybór języka, stylu i rozmiaru oraz obsługę przez dostępny odtwarzacz.],
)

== Audiodeskrypcja

Audiodeskrypcja opisuje istotne informacje wizualne: kto, co, gdzie, kiedy i jak robi. Powinna być zwięzła, obiektywna, zsynchronizowana i nie powinna dopisywać intencji, których nie widać.

#good[
  *Opisuj* to, co widać i co jest ważne dla zrozumienia akcji.\
  *Unikaj* interpretacji typu „bohater jest smutny", jeżeli nie wynika to jasno z obrazu.\
  *Testuj:* sprawdź, czy osoba bez obrazu rozumie kluczową treść filmu.
]

== Audiodeskrypcja vs transkrypcja: co pokrywa więcej?

To zależy od poziomu wymagań i typu materiału. W praktyce *transkrypcja rozszerzona pokrywa więcej warstw informacji*, bo może połączyć dialogi, ważne dźwięki, opis obrazu i kolejność wydarzeń w jednym tekście.

Audiodeskrypcja nie zastępuje napisów ani transkrypcji audio, bo opisuje przede wszystkim warstwę wizualną.

#exam[
  Transkrypcja rozszerzona jest najbardziej pojemna informacyjnie jako tekst, ale na poziomie AA WCAG dla nagranego wideo z dźwiękiem sama transkrypcja zwykle *nie zwalnia* z obowiązku zapewnienia audiodeskrypcji, gdy kryterium 1.2.5 ma zastosowanie.
]

#styled-table(
  columns: (1fr, 1.5fr, 1.5fr),
  header: ("Alternatywa", "Co obejmuje?", "Kiedy szczególnie pomaga?"),
  [Audiodeskrypcja], [Istotne informacje wizualne dodane jako opis dźwiękowy.], [Gdy użytkownik słyszy materiał, ale nie widzi obrazu.],
  [Transkrypcja podstawowa], [Tekstową wersję wypowiedzi i ważnych dźwięków.], [Przy podcastach, nagraniach audio, szybkim przeszukiwaniu treści.],
  [Transkrypcja rozszerzona], [Dialogi, ważne dźwięki, opisy obrazu i kolejność wydarzeń.], [Gdy trzeba przekazać pełny sens materiału osobie, która nie korzysta ani z obrazu, ani z dźwięku.],
)

=== Techniczne wdrożenie

Dla napisów można używać znacznika `track` i formatu WebVTT. Dla audiodeskrypcji sytuacja jest trudniejsza: sama obecność `track kind="descriptions"` nie gwarantuje, że opis będzie faktycznie dostępny. Często stosuje się osobną wersję filmu z audiodeskrypcją, dostępny odtwarzacz albo logikę synchronizacji audio/wideo.

#warning[
  Automatyczny test nie oceni jakości audiodeskrypcji, sensu napisów ani tego, czy alternatywa rzeczywiście pomaga użytkownikowi. Tu potrzebna jest *ocena człowieka*.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 7 — ARIA                     ║
// ╚══════════════════════════════════════════╝

= 7. ARIA, linki i komponenty interaktywne

ARIA pozwala dodawać semantykę do komponentów, które nie mają jej wystarczająco w HTML. Pomaga technologiom asystującym zrozumieć role, stany i właściwości elementów. Ale ARIA *nie dodaje automatycznie zachowania*.

#keybox[
  *Złota zasada ARIA:* Najpierw użyj poprawnego HTML. ARIA stosuj tylko wtedy, gdy jest naprawdę potrzebna.
]

== Role, stany i właściwości

#styled-table(
  columns: (0.8fr, 1.5fr, 2fr),
  header: ("Typ", "Przykład", "Do czego służy?"),
  [Rola], [`role="button"`, `role="dialog"`], [Mówi, czym jest element.],
  [Stan], [`aria-expanded="true"`], [Mówi, jaki jest bieżący stan elementu.],
  [Właściwość], [`aria-label="Zamknij"`], [Dostarcza dodatkowe informacje, np. nazwę.],
  [Relacja], [`aria-labelledby="id"`], [Łączy element z innym elementem jako etykietą lub opisem.],
  [Region live], [`aria-live="polite"`], [Ogłasza dynamiczne zmiany treści.],
)

== Link czy przycisk?

#styled-table(
  columns: (1.5fr, 1.2fr, 1.5fr),
  header: ("Sytuacja", "Element", "Dlaczego?"),
  [Przejście na inną stronę.], [`<a href="...">`], [To nawigacja do zasobu.],
  [Przejście do sekcji na tej samej stronie.], [`<a href="#sekcja">`], [To link lokalny.],
  [Otworzenie modala.], [`<button>`], [To akcja w interfejsie.],
  [Rozwinięcie menu.], [`<button aria-expanded="...">`], [To kontrolka zmieniająca stan.],
  [Wysłanie formularza.], [`<button type="submit">`], [To akcja formularza.],
)

=== Wzorzec linku z WAI-ARIA APG

Link jest interaktywnym odniesieniem do zasobu, lokalnego albo zewnętrznego. Wzorzec APG zachęca do używania natywnego elementu `<a href>`. Samo `role="link"` nie daje standardowych zachowań przeglądarki, takich jak nawigacja, menu kontekstowe czy typowe działanie klawiatury.

== Najczęstsze błędy ARIA

- Dodanie roli bez obsługi klawiatury.
- Użycie `aria-hidden="true"` na ważnej treści.
- Nieaktualizowanie `aria-expanded` po otwarciu lub zamknięciu menu.
- Nadanie elementowi złej roli, np. link udający przycisk.
- Nadmiarowe role na natywnych elementach, które już mają semantykę.


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 8 — AUDYT                    ║
// ╚══════════════════════════════════════════╝

= 8. Audyt: jak opisywać błędy

Dobry audyt nie polega tylko na znalezieniu błędu. Trzeba wyjaśnić, *kogo problem dotyczy*, jakie *kryterium narusza*, gdzie go znaleźć i jak go *naprawić*.

#keybox[
  *Schemat:* Problem → kryterium → wpływ na użytkownika → dowód → rekomendacja.
]

#styled-table(
  columns: (1fr, 1.5fr, 2fr),
  header: ("Część raportu", "Pytanie pomocnicze", "Przykład"),
  [Problem], [Co dokładnie jest nie tak?], [Przycisk zamknięcia modala nie ma nazwy dostępnej.],
  [Kryterium], [Do którego wymagania WCAG to pasuje?], [4.1.2 Nazwa, rola, wartość.],
  [Wpływ], [Komu to przeszkadza i jak?], [Osoba używająca czytnika słyszy tylko „przycisk".],
  [Dowód], [Gdzie i jak to sprawdzono?], [Modal koszyka, test NVDA + Chrome.],
  [Rekomendacja], [Co zmienić?], [Dodać widoczną etykietę albo `aria-label="Zamknij"`.],
)

== Przykłady gotowych opisów

#block(
  width: 100%,
  radius: 8pt,
  inset: (x: 16pt, y: 12pt),
  fill: gray-soft,
  stroke: 0.5pt + gray-border,
)[
  *Fokus.* Problem: fokus klawiatury nie jest widoczny na linkach w menu. Wpływ: użytkownik klawiatury nie wie, gdzie aktualnie się znajduje. Rekomendacja: dodać wyraźny styl `:focus-visible` z odpowiednim kontrastem.

  *Multimedia.* Problem: film instruktażowy ma napisy, ale nie ma audiodeskrypcji scen, które pokazują kolejność kliknięć. Wpływ: osoba niewidoma nie odtworzy instrukcji. Rekomendacja: dodać audiodeskrypcję albo rozszerzoną transkrypcję opisującą działania na ekranie.

  *Formularz.* Problem: pole „Telefon" pokazuje błąd tylko czerwonym obramowaniem. Wpływ: osoba nierozróżniająca kolorów lub korzystająca z czytnika może nie zauważyć błędu. Rekomendacja: dodać tekstowy komunikat błędu i powiązać go z polem.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 9 — KRYTERIA WCAG            ║
// ╚══════════════════════════════════════════╝

= 9. Rozdział powtórkowy: kryteria WCAG 2.1/2.2

Ten rozdział zbiera kryteria najważniejsze dla praktycznego audytu na poziomach A i AA, z uwzględnieniem dodatków WCAG 2.2. Ucz się ich nie jako suchych numerów, ale jako _pytań kontrolnych_: co sprawdzam, kogo dotyczy problem i jak opisać rekomendację.

== 1. Zasada: Postrzegalność (Perceivable)

_Informacje i komponenty interfejsu muszą być przedstawione w sposób czytelny dla zmysłów._

#styled-table(
  columns: (1.2fr, 2fr, 2.5fr),
  header: ("Nr i opis", "Opis na ludzki język", "Rozbudowane przykłady"),
  [*1.1.1* Treść nietekstowa (A)], [Każdy element graficzny, który nie jest tekstem, a niesie informację, musi mieć tekstowy zamiennik, najczęściej `alt`. Elementy dekoracyjne powinny być technicznie ukryte przed czytnikami.], [1. Zdjęcie w artykule o górach: `alt="Zaśnieżone szczyty Tatr o wschodzie słońca"`. 2. Przycisk wyszukiwania z ikoną lupy ma ukrytą etykietę `aria-label="Szukaj"`.],
  [*1.2.1* Audio i wideo (nagrane) (A)], [Dla nagrań dźwiękowych wymagana jest transkrypcja. Dla filmów bez dźwięku potrzebny jest opis tekstowy lub ścieżka audio opisująca akcję.], [1. Pod podcastem znajduje się pełny zapis rozmowy. 2. Niemy film pokazujący montaż mebla ma listę kroków w formie tekstowej pod odtwarzaczem.],
  [*1.2.2* Napisy (nagrane) (A)], [Filmy z dźwiękiem muszą mieć napisy, które obejmują dialogi oraz istotne dźwięki otoczenia, np. wybuch, muzykę albo pukanie do drzwi.], [1. Film ma napisy: \[Jan\]: Proszę wejść. \[słychać skrzypienie drzwi\]. 2. Napisy informują o nastroju muzyki, jeśli jest ona kluczowa dla sceny.],
  [*1.2.3* Audiodeskrypcja lub alternatywa (A) / *1.2.5* Audiodeskrypcja (AA)], [Istotne informacje wizualne w filmie muszą zostać opisane tekstowo albo przez lektora. Na poziomie AA audiodeskrypcja jest wymagana.], [1. W przerwie między dialogami lektor mówi: "Bohater wyjmuje z szuflady pistolet i chowa go za pas". 2. W wideo-szkoleniu opisane są wykresy.],
  [*1.2.4* Napisy (na żywo) (AA)], [Transmisje online muszą posiadać napisy generowane na bieżąco.], [1. Podczas relacji na żywo z obrad rady miasta na dole ekranu pojawiają się napisy przygotowywane przez stenotypistę albo usługę live captioning.],
  [*1.3.1* Struktura i powiązania (A)], [Informacje i struktura strony muszą być poprawnie zakodowane, aby czytnik wiedział, co jest czym.], [1. Tytuł sekcji jest oznaczony jako `<h2>`, a nie tylko pogrubionym tekstem. 2. Tabela ma zdefiniowane nagłówki kolumn `<th>`.],
  [*1.3.2* Zrozumiała kolejność (A)], [Kod strony musi być ułożony tak, aby czytnik ekranu czytał treści w logicznej kolejności.], [1. W dwukolumnowym układzie czytnik najpierw czyta całą lewą kolumnę, a potem prawą.],
  [*1.3.3* Charakterystyki sensoryczne (A)], [Instrukcje nie mogą polegać wyłącznie na kształcie, kolorze, dźwięku lub położeniu.], [1. Zamiast „Kliknij okrągłą ikonę po prawej", instrukcja brzmi: „Wybierz przycisk Dalej, znajdujący się w prawym dolnym rogu".],
  [*1.3.4* Orientacja (AA)], [Strona nie może blokować orientacji wyświetlania.], [1. Formularz bankowy działa poprawnie zarówno pionowo, jak i poziomo.],
  [*1.3.5* Rozpoznanie przeznaczenia (AA)], [Pola formularzy zbierające dane o użytkowniku muszą być odpowiednio oznaczone, np. przez `autocomplete`.], [1. Przeglądarka automatycznie podpowiada zapisany adres e-mail dzięki `autocomplete="email"`.],
  [*1.4.1* Użycie koloru (A)], [Kolor nie może być jedynym sposobem przekazywania informacji.], [1. Linki w tekście są podkreślone, a nie tylko niebieskie. 2. Błąd w formularzu ma ikonę wykrzyknika i tekst.],
  [*1.4.2* Kontrola dźwięku (A)], [Dźwięk odtwarzany automatycznie dłużej niż 3 sekundy musi dać się wyłączyć.], [1. Wideo startujące automatycznie ma widoczny przycisk Wycisz dostępny klawiaturą.],
  [*1.4.3* Kontrast minimalny (AA)], [Tekst musi wyraźnie odcinać się od tła: minimum 4.5:1 dla zwykłego tekstu i 3:1 dla dużego.], [1. Zamiast jasnoszarego tekstu na białym tle użyto ciemnej czcionki na jasnym, jednolitym tle.],
  [*1.4.4* Zmiana rozmiaru tekstu (AA)], [Tekst musi dać się powiększyć do 200% bez utraty treści.], [1. Osoba słabowidząca powiększa stronę — tekst nie nachodzi na inne elementy.],
  [*1.4.5* Obrazy tekstu (AA)], [Należy unikać tekstów w formie grafiki, jeśli można użyć zwykłego tekstu.], [1. Zamiast obrazka z cennikiem, tworzy się tabelę w HTML.],
  [*1.4.10* Zawijanie treści (AA)], [Treść musi dostosowywać się bez przewijania w poziomie, do 320 px.], [1. Przy powiększeniu do 400% menu i treść układają się jedno pod drugim.],
  [*1.4.11* Kontrast elementów nietekstowych (AA)], [Elementy interfejsu muszą mieć kontrast minimum 3:1 względem tła.], [1. Granica pola tekstowego jest wyraźnie widoczna.],
  [*1.4.12* Odstępy w tekście (AA)], [Zmiana odstępów nie może powodować utraty treści ani funkcjonalności.], [1. Użytkownik nakłada własny styl CSS zwiększający interlinię — tekst się nie ucina.],
  [*1.4.13* Treść po najechaniu lub fokusie (AA)], [Dodatkowa treść, np. tooltip, musi być możliwa do odrzucenia i utrzymania.], [1. Podpowiedź można zamknąć klawiszem Esc bez ruszania myszą.],
)

== 2. Zasada: Funkcjonalność (Operable)

_Komponenty interfejsu i nawigacja muszą być możliwe do użycia._

#styled-table(
  columns: (1.2fr, 2fr, 2.5fr),
  header: ("Nr i opis", "Opis na ludzki język", "Rozbudowane przykłady"),
  [*2.1.1* Klawiatura (A)], [Każda funkcja strony musi być dostępna za pomocą samej klawiatury.], [1. Użytkownik przechodzi przez menu klawiszem Tab i rozwija podmenu Enterem albo spacją.],
  [*2.1.2* Brak pułapki klawiaturowej (A)], [Fokus nie może utknąć w żadnym elemencie.], [1. Po otwarciu okna z regulaminem użytkownik może je zamknąć Esc i wrócić do treści.],
  [*2.1.4* Skróty klawiszowe znakowe (A)], [Skróty jednoliterowe muszą dać się wyłączyć lub zmienić.], [1. Skrót „M" otwierający menu można wyłączyć, aby nie kolidował z dyktowaniem.],
  [*2.2.1* Dostosowanie czasu (A)], [Użytkownik musi móc wyłączyć lub wydłużyć limity czasowe.], [1. Na 2 min przed końcem sesji pojawia się komunikat z opcją przedłużenia.],
  [*2.2.2* Pauza, zatrzymanie, ukrycie (A)], [Poruszające się lub automatycznie aktualizujące się treści muszą mieć mechanizm zatrzymania.], [1. Slider na stronie głównej ma widoczny przycisk Stop.],
  [*2.3.1* Trzy błyski (A)], [Treści nie mogą migać częściej niż 3 razy na sekundę.], [1. Strona nie używa agresywnych banerów z pulsującym światłem.],
  [*2.4.1* Ominięcie bloków (A)], [Należy zapewnić mechanizm przeskoczenia powtarzających się bloków.], [1. Pierwsze Tab aktywuje link „Przejdź do głównej treści".],
  [*2.4.2* Tytuł strony (A)], [Każda podstrona musi mieć unikalny i opisowy `<title>`.], [1. Karta w przeglądarce: „Kontakt - Sklep XYZ" zamiast „Sklep".],
  [*2.4.3* Kolejność fokusu (A)], [Nawigacja klawiaturą musi odbywać się w logicznej kolejności.], [1. Fokus przechodzi przez formularz od góry do dołu.],
  [*2.4.4* Cel linku w kontekście (A)], [Tekst linku musi jasno określać, dokąd prowadzi.], [1. Link brzmi „Pobierz raport PDF (12 MB)" zamiast „Pobierz".],
  [*2.4.5* Wiele dróg (AA)], [Do podstrony powinny prowadzić co najmniej dwie drogi.], [1. Użytkownik znajduje cennik przez wyszukiwarkę.],
  [*2.4.6* Nagłówki i etykiety (AA)], [Nagłówki i opisy pól muszą być konkretne i zrozumiałe.], [1. „Parametry techniczne pralki" lepsze niż „Informacje".],
  [*2.4.7* Widoczny fokus (AA)], [Każdy element z fokusem musi być wyraźnie widoczny.], [1. Wokół przycisku pojawia się kontrastowa ramka.],
  [*2.4.11* Fokus nieprzesłonięty minimum (AA, 2.2)], [Aktywny element nie może być całkowicie zakryty.], [1. Przycisk w stopce nie jest zasłonięty przez sticky baner.],
  [*2.5.1* Gesty dotykowe (A)], [Funkcje obsługiwane złożonymi gestami muszą być dostępne prostszym gestem.], [1. Mapę można przesuwać też przyciskami Góra/Dół/Lewo/Prawo.],
  [*2.5.2* Rezygnacja ze wskazania (A)], [Akcja nie powinna uruchamiać się nieodwracalnie przy naciśnięciu.], [1. Użytkownik naciska „Usuń", odsuwa wskaźnik, akcja się nie wykonuje.],
  [*2.5.3* Etykieta w nazwie (A)], [Tekst widoczny na przycisku musi być częścią jego nazwy technicznej.], [1. Przycisk „Wyślij" jest rozpoznawany głosem jako „Wyślij".],
  [*2.5.4* Ruch urządzenia (A)], [Funkcje wyzwalane ruchem muszą mieć alternatywę w interfejsie.], [1. Zamiast potrząsać telefonem, klika się przycisk „Cofnij".],
  [*2.5.7* Gesty przeciągania (AA, 2.2)], [Jeśli coś wymaga przeciągania, musi dać się zrobić bez niego.], [1. Na liście zadań kolejność zmienia się strzałkami Góra/Dół.],
  [*2.5.8* Rozmiar celu minimum (AA, 2.2)], [Elementy klikalne muszą być odpowiednio duże lub oddalone.], [1. Ikony w menu mobilnym mają wystarczający odstęp.],
)

== 3. Zasada: Zrozumiałość (Understandable)

_Informacje i obsługa interfejsu muszą być zrozumiałe._

#styled-table(
  columns: (1.2fr, 2fr, 2.5fr),
  header: ("Nr i opis", "Opis na ludzki język", "Rozbudowane przykłady"),
  [*3.1.1* Język strony (A)], [Główny język strony musi być zdefiniowany, np. `lang="pl"`.], [1. Czytnik wie, że ma użyć polskiego syntezatora mowy.],
  [*3.1.2* Język części treści (AA)], [Obcojęzyczne fragmenty muszą być oznaczone odpowiednim językiem.], [1. Zdanie po łacinie: `<span lang="la">`, czytnik przeczyta je poprawnie.],
  [*3.2.1* Po fokusie (A)], [Fokus na elemencie nie może powodować niespodziewanej zmiany kontekstu.], [1. Tab przez pola nie otwiera nagle nowej karty.],
  [*3.2.2* Podczas wprowadzania (A)], [Zmiana wartości pola nie może zmieniać kontekstu bez ostrzeżenia.], [1. Zaznaczenie „Dostawa kurierem" nie wysyła automatycznie zamówienia.],
  [*3.2.3* Spójna nawigacja (AA)], [Elementy nawigacyjne muszą występować w tej samej kolejności.], [1. Menu główne i wyszukiwarka są zawsze na górze.],
  [*3.2.4* Spójna identyfikacja (AA)], [Elementy o tej samej funkcji muszą mieć spójne nazwy.], [1. Ikona lupy zawsze służy do wyszukiwania.],
  [*3.2.6* Spójna pomoc (A, 2.2)], [Pomoc powinna być w tym samym miejscu na kolejnych stronach.], [1. Widżet czatu zawsze w prawym dolnym rogu.],
  [*3.3.1* Identyfikacja błędów (A)], [Błędy w formularzach muszą być opisane tekstowo.], [1. „Błąd: wpisz dokładnie 9 cyfr" nad polem telefonu.],
  [*3.3.2* Etykiety lub instrukcje (A)], [Każde pole musi mieć jasny podpis.], [1. Pole podpisane „PESEL (11 cyfr)" zamiast pustego okienka.],
  [*3.3.3* Sugestie błędów (AA)], [System powinien podpowiadać, jak naprawić błąd.], [1. „Wpisz datę w formacie DD.MM.RRRR".],
  [*3.3.4* Zapobieganie błędom (AA)], [W ważnych formularzach użytkownik musi móc sprawdzić dane.], [1. Ekran podsumowania przed przelewem.],
  [*3.3.7* Powtarzanie danych (A, 2.2)], [System nie powinien kazać wpisywać danych drugi raz.], [1. „Adres dostawy taki sam jak na fakturze".],
  [*3.3.8* Uwierzytelnianie dostępne (AA, 2.2)], [Logowanie nie może wymagać trudnych testów poznawczych.], [1. Serwis pozwala wkleić hasło z menedżera haseł.],
)

== 4. Zasada: Solidność (Robust)

#block(breakable: false)[
_Treść musi być wystarczająco solidna, by mogła być poprawnie interpretowana przez różne programy._

#styled-table(
  columns: (1.2fr, 2fr, 2.5fr),
  header: ("Nr i opis", "Opis na ludzki język", "Rozbudowane przykłady"),
  [*4.1.2* Nazwa, rola, wartość (A)], [Każdy przycisk, menu, suwak czy pole musi przekazywać czytnikowi, czym jest, jak się nazywa i jaki ma stan.], [1. Przycisk akordeon informuje czytnik: „Rozwiń sekcję, stan: zwinięty".],
  [*4.1.3* Komunikaty o stanie (AA)], [Nowe komunikaty muszą być odczytywane bez przenoszenia fokusu.], [1. Po dodaniu produktu czytnik mówi: „Produkt został dodany", bez przenoszenia fokusu.],
)
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 10 — CHECKLISTY              ║
// ╚══════════════════════════════════════════╝

= 10. Checklisty egzaminacyjne

Używaj tych list podczas ćwiczeń. Najlepiej weź prawdziwą stronę i przejdź po kolei wszystkie sekcje.

== Checklista: 4 zasady POUR

#styled-table(
  columns: (1fr, 3fr),
  header: ("Zasada", "Sprawdź"),
  [Postrzegalność], [#checkbox Obrazy informacyjne mają tekst alternatywny.\ #checkbox Kontrast jest wystarczający.\ #checkbox Multimedia mają alternatywy.],
  [Funkcjonalność], [#checkbox Cała strona działa z klawiatury.\ #checkbox Fokus jest widoczny.\ #checkbox Nie ma pułapki klawiaturowej.],
  [Zrozumiałość], [#checkbox Etykiety formularzy są jasne.\ #checkbox Błędy są opisane tekstowo.\ #checkbox Nawigacja jest spójna.],
  [Solidność], [#checkbox HTML jest semantyczny.\ #checkbox Komponenty mają nazwę, rolę i stan.\ #checkbox ARIA jest aktualna i potrzebna.],
)

== Checklista: multimedia

#block(breakable: false)[
#checkbox Materiał tylko audio ma transkrypcję.\
#checkbox Materiał tylko wideo ma opis tekstowy albo audiodeskrypcję.\
#checkbox Nagrane wideo z dźwiękiem ma napisy rozszerzone.\
#checkbox Nagrane wideo z dźwiękiem ma audiodeskrypcję, gdy obraz niesie ważną treść.\
#checkbox Transmisja na żywo ma napisy rozszerzone, jeśli wymagany jest poziom AA.\
#checkbox Napisy zawierają ważne dźwięki, a nie tylko dialogi.\
#checkbox Odtwarzacz działa z klawiaturą.\
#checkbox Przyciski odtwarzacza mają nazwy dostępne.
]

== Checklista: ARIA

#block(breakable: false)[
#checkbox Sprawdzono, czy da się użyć natywnego HTML.\
#checkbox Rola odpowiada rzeczywistemu zachowaniu.\
#checkbox Element ma nazwę dostępną.\
#checkbox Element jest dostępny z klawiatury.\
#checkbox Stany, np. `aria-expanded`, zmieniają się wraz z interakcją.\
#checkbox `aria-hidden` nie ukrywa ważnej treści.\
#checkbox Komunikaty dynamiczne są testowane czytnikiem ekranu.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 11 — FISZKI                  ║
// ╚══════════════════════════════════════════╝

= 11. Fiszki i plan powtórki

== Fiszki

#styled-table(
  columns: (1.5fr, 2.5fr),
  header: ("Pytanie", "Odpowiedź"),
  [Co oznacza POUR?], [Postrzegalność, Funkcjonalność, Zrozumiałość, Solidność.],
  [Kiedy obraz ma `alt=""`?], [Gdy jest dekoracyjny i nie niesie informacji.],
  [Link czy przycisk?], [Link prowadzi do zasobu. Przycisk wykonuje akcję.],
  [Co to jest fokus?], [Aktualnie aktywny element interfejsu podczas obsługi klawiaturą.],
  [Co to są napisy rozszerzone?], [Napisy z dialogami, identyfikacją mówiących i ważnymi dźwiękami.],
  [Czy ARIA zmienia zachowanie elementu?], [Nie. ARIA przekazuje semantykę; zachowanie trzeba zapewnić osobno.],
  [Co oznacza 4.1.2?], [Komponent ma mieć programowo określoną nazwę, rolę, stan i wartość.],
  [Czy automat wystarczy do audytu?], [Nie. Automaty nie ocenią sensu, kontekstu ani jakości wielu rozwiązań.],
)

== 7-dniowy plan nauki

#block(breakable: false)[
#styled-table(
  columns: (0.5fr, 1.2fr, 2.5fr),
  header: ("Dzień", "Temat", "Ćwiczenie"),
  [1], [Podstawy WCAG i POUR.], [Wypisz po 3 przykłady błędów dla każdej zasady.],
  [2], [Postrzegalność.], [Sprawdź obrazy, kontrast i multimedia na jednej stronie.],
  [3], [Funkcjonalność.], [Przejdź stronę tylko klawiaturą.],
  [4], [Zrozumiałość.], [Przetestuj formularz i opisz błędy.],
  [5], [Solidność i ARIA.], [Znajdź 5 komponentów i sprawdź nazwę, rolę, stan.],
  [6], [Multimedia.], [Oceń film: napisy, audiodeskrypcja, transkrypcja, sterowanie.],
  [7], [Raportowanie.], [Przygotuj 8 opisów błędów według schematu raportowego.],
)
]

#exam(title: "Powtórka last minute")[
  Na każdy błąd odpowiedz: co jest problemem, kogo dotyczy, które kryterium narusza i jak to naprawić.
]


// ╔══════════════════════════════════════════╗
// ║     CHAPTER 12 — KONTEKST PRAWNY         ║
// ╚══════════════════════════════════════════╝

= 12. Kontekst prawny i przyszłość WCAG

Egzamin może sprawdzać nie tylko techniczne rozumienie WCAG, ale też świadomość, że dostępność jest częścią obowiązków prawnych i jakości usług cyfrowych.

== Polski Akt o Dostępności

Ustawa z dnia 26 kwietnia 2024 r. o zapewnianiu spełniania wymagań dostępności niektórych produktów i usług przez podmioty gospodarcze wdraża wymagania Europejskiego Aktu o Dostępności. W źródłach prawnych występuje jako Dz.U. 2024 poz. 731.

== WCAG 3.0

WCAG 3.0 jest projektem przyszłych wytycznych. Nie zastępuje w praktyce bieżącej nauki WCAG 2.1/2.2. Do egzaminu najważniejsze są nadal zasady POUR, kryteria sukcesu WCAG 2.x i praktyczne umiejętności audytorskie.

== Deklaracja dostępności

Każdy podmiot publiczny musi mieć deklarację dostępności przygotowaną w sposób dostępny cyfrowo. Powinna zawierać m.in.:

- datę publikacji i datę ostatniej aktualizacji,
- sposób oceny dostępności,
- dane kontaktowe osoby lub komórki odpowiedzialnej za dostępność,
- informacje o skrótach klawiszowych,
- dostępność architektoniczną,
- informację o tłumaczu PJM,
- możliwość zgłoszenia braku dostępności.

#warning(title: "Nie myl")[
  WAI-ARIA 1.3 i WCAG 3.0 to dokumenty rozwijane. Do codziennego audytu podstawą są stabilne wymagania WCAG 2.x i praktyki wdrożeniowe.
]


// ╔══════════════════════════════════════════╗
// ║     SOURCES                              ║
// ╚══════════════════════════════════════════╝

#pagebreak()
#v(1cm)
#text(22pt, weight: "bold", fill: purple-deep)[Źródła]
#v(0.3cm)
#line(length: 30%, stroke: 2pt + violet-soft)
#v(0.6cm)

#set text(8.5pt)

\[S1\] W3C, _Wytyczne dla dostępności treści internetowych (WCAG) 2.1_ — polskie tłumaczenie: https://www.w3.org/Translations/WCAG21-pl/

\[S2\] LepszyWeb, _Jak spełnić WCAG — Krótki przewodnik_: https://wcag.lepszyweb.pl/

\[S3\] W3C WAI-ARIA APG, _Link Pattern_: https://www.w3.org/WAI/ARIA/apg/patterns/link/

\[S4\] W3C, _Accessible Rich Internet Applications (WAI-ARIA) 1.3_: https://www.w3.org/TR/wai-aria-1.3/

\[S5\] MDN Web Docs, _WAI-ARIA basics_: https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Accessibility/WAI-ARIA_basics

\[S6\] AAArdvark Accessibility, _1.1.1 Non-text Content_: https://aaardvarkaccessibility.com/wcag-plain-english/1-1-1-non-text-content/

\[S7\] W3C, _W3C Accessibility Guidelines (WCAG) 3.0_: https://www.w3.org/TR/wcag-3.0/

\[S8\] Materiał szkoleniowy użytkowniczki: _Dostępne multimedia_ — a11yfirst.pptx.

\[S9\] Ustawa z dnia 26 kwietnia 2024 r. o zapewnianiu spełniania wymagań dostępności niektórych produktów i usług przez podmioty gospodarcze, Dz.U. 2024 poz. 731: https://eli.gov.pl/eli/DU/2024/731/ogl/pol/pdf
