extends Resource
class_name DateTime

@export_range(0,59) var seconds: int = 0
@export_range(0,59) var minutes: int = 0
@export_range(0,59) var hours: int = 0
@export var days: int = 0

var seasons: Array = ["Spring", "Summer", "Fall", "Winter"]

var delta_time: float = 0
var current_season: String = "Spring"

signal season_changed(new_season: String)
signal morning_coming
signal day_over
signal week_changed(new_week: int)

var day_over_emitted: bool = false
var last_day: int = -1
var last_week: int = -1

func increase_by_sec(delta_seconds: float):
	delta_time += delta_seconds
	if delta_time < 1:
		return
	
	var delta_int_secs: int = delta_time
	delta_time -= delta_int_secs
	
	seconds += delta_int_secs
	minutes += seconds / 60
	hours += minutes / 60
	days += hours / 24
	
	seconds = seconds % 60
	minutes = minutes % 60
	hours = hours % 24

	update_season()
	check_and_emit_signals()

func update_season():
	var season_index: int = (days / 20) % 4
	var previous_season = current_season
	current_season = seasons[season_index]
	if current_season != previous_season:
		emit_signal("season_changed", current_season)
		MoneyManager.season_item_left.clear()

func check_and_emit_signals():
	if hours == 6 and last_day != days:
		last_day = days
		emit_signal("morning_coming")
		day_over_emitted = false

	if hours == 22 and !day_over_emitted:
		emit_signal("day_over")
		day_over_emitted = true

	var current_week = (days / 7) % 12
	if current_week != last_week:
		last_week = current_week
		emit_signal("week_changed", current_week)

func get_current_season() -> String:
	return current_season

func get_days_in_season() -> int:
	return days % 28

func to_dict() -> Dictionary:
	return {
		"seconds": seconds,
		"minutes": minutes,
		"hours": hours,
		"days": days,
		"current_season": current_season,
		"last_day": last_day,
		"last_week": last_week
	}

static func from_dict(data: Dictionary) -> DateTime:
	var date_time = DateTime.new()
	date_time.seconds = data.get("seconds", 0)
	date_time.minutes = data.get("minutes", 0)
	date_time.hours = data.get("hours", 6)
	date_time.days = data.get("days", 0)
	date_time.current_season = data.get("current_season", "Spring")
	date_time.last_day = data.get("last_day", -1)
	date_time.last_week = data.get("last_week", -1)
	date_time.last_day -= 1 
	return date_time

# 加载默认时间数据
static func load_default_time_data() -> DateTime:
	var default_time_data = {
		"seconds": 0,
		"minutes": 0,
		"hours": 6,
		"days": 1,
		"current_season": "Spring",
		"last_day": -1,
		"last_week": -1
	}
	return DateTime.from_dict(default_time_data)

func set_to_morning():
	emit_signal("day_over")
	
	seconds = 0
	minutes = 0
	hours = 6
	days += 1
	update_season()

