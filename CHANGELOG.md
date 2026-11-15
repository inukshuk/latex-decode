# Changelog

## 0.5.0 (unreleased)

### Added
- Math in `$…$`, `\(…\)`, `$$…$$` or `\[…\]` is converted to Unicode
  if all of it can be represented;
  otherwise it is kept as it is, including the delimiters.
  Text decoding no longer mangles math.
- The `math: false` option keeps all math as it is.

### Changed
- Ruby 3.2 or later is required.
- `LaTeX.decoders` is frozen.

### Removed
- MathML conversion via the `ritex` or `math_ml` gems.
  The `maths: false` option is ignored.

### Fixed
- `\Delta` decodes to Greek Δ (U+0394)
  instead of the increment sign ∆ (U+2206).
- `\pi` and `\Pi` are decoded.
- `\set` is no longer decoded to ∅.
