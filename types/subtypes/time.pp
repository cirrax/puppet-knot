# subtype: Number of seconds, an integer
#  with a possible time multiplier suffix 
# (s ~ 1, m ~ 60, h ~ 3600, d ~ 24 * 3600, w ~ 7 * 24 * 3600, M ~ 30 * 24 * 3600, y ~ 365 * 24 * 3600)
type Knot::Subtypes::Time = Variant[Integer, String[1]]
