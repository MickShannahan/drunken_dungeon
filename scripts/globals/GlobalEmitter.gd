extends Node

# Dictionary to store custom signals dynamically
var custom_signals: Dictionary[String, Signal] = {}

func _ready() -> void:
	set_name("GlobalEmitter")

# Get or create a signal by name
func get_signal(signal_name: String) -> Signal:
	if not custom_signals.has(signal_name):
		# Add user signal if it doesn't exist
		if not has_user_signal(signal_name):
			add_user_signal(signal_name)
		custom_signals[signal_name] = Signal(self, signal_name)
	return custom_signals[signal_name]

# Connect to a custom signal
func connect_to_signal(signal_name: String, callable: Callable) -> void:
	print('🔌', signal_name, callable)
	get_signal(signal_name).connect(callable)

# Emit a custom signal with any number of arguments
func emit(signal_name: String, args: Array = []) -> void:
	var sig = get_signal(signal_name)
	print('📢' + signal_name, args, sig)
	sig.emit.callv(args)
