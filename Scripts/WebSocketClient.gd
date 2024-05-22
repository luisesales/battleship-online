extends Node

var socket = WebSocketPeer.new()
var lastState = WebSocketPeer.STATE_CLOSED

signal connectedToServer()
signal connectionClosed()
signal messageRecieved(message: Variant)

func poll() :
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
		
	var state = socket.get_ready_state()
	
	if lastState != state :
		lastState = state
		
		if state == socket.STATE_OPEN :
			connectedToServer.emit()
		elif state == socket.STATE_CLOSED :
			connectionClosed.emit()
	
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count() :
		messageRecieved.emit(getMessage())

func getMessage() -> Variant :
	if socket.get_available_packet_count() < 1 :
		return null
		
	var packet = socket.get_packet()
	if socket.was_string_packet() :
		return packet.get_string_from_utf8()
		
	return bytes_to_var(packet)

func send(message) -> int :
	if typeof(message) == TYPE_STRING :
		return socket.send_text(message)
	return socket.send(var_to_bytes(message))
	
func connectToURL(url) -> int :
	var error = socket.connect_to_url(url)
	if error != OK :
		return error
	
	lastState = socket.get_ready_state()
	return OK
	
func close(code := 1000, reason := "") :
	socket.close(code,reason)
	lastState = socket.get_ready_state()
	
func clear() :
	print("clear")
	
func getSocket() -> WebSocketPeer : 
	return socket

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	poll()
