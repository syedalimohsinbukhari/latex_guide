-- callouts.lua — map fenced Divs to tcolorbox environments (LaTeX/PDF output).
--
-- Usage in Markdown (blank line before/after the fences):
--   ::: objective        ::: exercise        ::: capstone        ::: important
--   ...                  ...                 ...                 ...
--   :::                  :::                 :::                 :::
--
--   ::: nuance
--   **the specific subtitle**   <- rendered as a bold lead-in inside the box
--
--   ...body markdown (code spans, **bold**, lists, code blocks all render)...
--   :::
--
--   ::: worked
--   **the example's subtitle**
--   ...
--   :::
--
--   ::: {.general title="Whatever heading you want"}
--   ...body markdown...
--   :::
--
--   ::: crosscheck                          ::: {.crosscheck title="Chapter 9"}
--   ...body markdown...                     ...body markdown...
--   :::                                     :::
--   <- renders as "Cross-Check"              <- renders as "Cross-Check: Chapter 9"
--
-- Each class needs a matching \newtcolorbox in the preamble.
-- Box titles are fixed per type ("Nuance", "Worked Example", ...); the specific subtitle lives
-- inside the box as bold text, which keeps this filter portable across Pandoc versions (no pandoc.read/write needed).
-- The exceptions are `general` and `crosscheck`: their title isn't fully fixed, so it's supplied via
-- an optional `title` attribute on the Div and passed through as the tcolorbox's #1 argument
-- (`crosscheck` additionally prepends its fixed "Cross-Check" text in Lua — no separate LaTeX
-- macro needed — and falls back to plain "Cross-Check" when no title attribute is given; `general`
-- has no fixed base text, so its title attribute is required). Unlike every other box's heading
-- text (fixed, or Markdown-rendered bold inline content), these titles come from a raw attribute
-- string — they are NOT parsed as Markdown, so bold/code spans inside a `title="..."` value will
-- render as literal characters, not formatted text.

local env = {
  objective  = "objectivebox",
  worked     = "workedbox",
  nuance     = "nuancebox",
  exercise   = "exercisebox",
  capstone   = "capstonebox",
  important  = "importantbox",
  general    = "generalbox",
  crosscheck = "crosscheckbox",
}

-- Classes whose title comes from a Div attribute rather than being fully fixed.
-- `base`: fixed text always present. `required`: error out if no title attribute
-- is given. The rendered title is `base` alone, or `base .. ": " .. title` when
-- a title attribute is present (base = "" for a class with no fixed text at all).
local titled = {
  general    = { base = "",            required = true  },
  crosscheck = { base = "Cross-Check", required = false },
}

-- Only `general`'s title needs escaping: every other box's title is a fixed
-- string baked into the preamble, but this one comes from author-written
-- Markdown attribute text that could contain raw LaTeX special characters.
--
-- Backslash is handled via a placeholder and swapped in LAST. Doing it first
-- (as a plain gsub to "\textbackslash{}") would inject literal { } characters
-- that the following character-class gsub would then re-escape, corrupting
-- the output (e.g. "a \ b" -> "a \textbackslash\{\} b" instead of the
-- correct "a \textbackslash{} b").
local function escape_latex(s)
  local PLACEHOLDER = "\1BACKSLASH\1"
  s = s:gsub('\\', PLACEHOLDER)
  s = s:gsub('([%%$#_{}&])', '\\%1')
  s = s:gsub('~', '\\textasciitilde{}')
  s = s:gsub('%^', '\\textasciicircum{}')
  s = s:gsub(PLACEHOLDER, '\\textbackslash{}')
  return s
end

-- Chapter headings ("## Chapter 9 — ...") render unnumbered in the PDF (no
-- --number-sections passed to Pandoc), so LaTeX's own \chapter counter never
-- advances — it stays frozen at its initial value. The box counters below
-- rely on "number within=chapter" (set in build_pdf.sh) to print e.g.
-- "Worked Example 9.1", which needs \thechapter to actually read 9. Since the
-- chapter number here is hand-typed text ("Chapter 9"), not a real LaTeX
-- count, sync the two: parse the number out of the heading and force the
-- counter to match, using \stepcounter (not \setcounter) so the reset-on-new-
-- chapter hook that "number within" relies on actually fires.
function Header(el)
  if el.level == 2 then
    local text = pandoc.utils.stringify(el.content)
    local n = text:match("Chapter%s+(%d+)")
    if n then
      return {
        el,
        pandoc.RawBlock('latex', '\\setcounter{chapter}{' .. (tonumber(n) - 1) .. '}\\stepcounter{chapter}'),
      }
    end
  end
  return nil
end

function Div(el)
  -- Warn (don't silently pick one) if a Div carries more than one recognized
  -- callout class — likely a copy-paste mistake, e.g. `.important .nuance`.
  local matched = pandoc.List()
  for _, cls in ipairs(el.classes) do
    if env[cls] then
      matched:insert(cls)
    end
  end

  if #matched == 0 then
    return nil
  end

  if #matched > 1 then
    io.stderr:write(
      "callouts.lua: WARNING — Div has multiple callout classes ("
        .. table.concat(matched, ", ")
        .. "); using '" .. matched[1] .. "' and ignoring the rest.\n"
    )
  end

  local cls = matched[1]
  local r = pandoc.List()

  if titled[cls] then
    local spec = titled[cls]
    local title = el.attributes["title"]
    local rendered
    if title and title ~= "" then
      rendered = (spec.base ~= "" and (spec.base .. ": ") or "") .. escape_latex(title)
    elseif spec.required then
      error("callouts.lua: '." .. cls .. "' box is missing a required title attribute, e.g. {." .. cls .. " title=\"...\"}")
    else
      rendered = spec.base
    end
    r:insert(pandoc.RawBlock('latex', '\\begin{' .. env[cls] .. '}{' .. rendered .. '}'))
  else
    r:insert(pandoc.RawBlock('latex', '\\begin{' .. env[cls] .. '}'))
  end

  r:extend(el.content)
  r:insert(pandoc.RawBlock('latex', '\\end{' .. env[cls] .. '}'))
  return r
end