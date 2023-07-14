extends Node2D


var dir = [1,1,1,1]
var input = -1
var cabletype = -1
var size = 32

var flow = 0
var flowing = false

var coords = Vector2(0,0)

export(Color) var electricity = Color(0,0,1)
export(Color) var audio_l = Color(1,1,1)
export(Color) var audio_r = Color(1,0,0)
export(Color) var video = Color(1,1,0)

var colors = [electricity,audio_l,audio_r,video]

signal output_flow(outputs, coords, cabletype)

# Called when the node enters the scene tree for the first time.
func _ready():
    set_lines()
    
func set_lines():
    var lines = $Lines.get_children()
    for i in len(lines):
        lines[i].width = size/4
        lines[i].get_child(0).width = size/4
        if dir[i]:
            lines[i].set_point_position(0, Vector2(size,0))
            lines[i].show()
        else:
            lines[i].set_point_position(0, Vector2(0,0))
            lines[i].hide()
    $Clickker.margin_top = -size
    $Clickker.margin_left = -size
    $Clickker.margin_bottom = size
    $Clickker.margin_right = size
    
            
func start_flow(inputflow, t, speed=1):
    if not dir[inputflow] or cabletype == t:
        return false
    if cabletype != -1: #double connect
        print("Räjähti!!!")
    cabletype = t
    input = inputflow
    flowing = true
    $Tween.interpolate_property(self, "flow", 0, 2, 1/speed)
    $Tween.start()
    for line in $Lines.get_children():
        line.get_child(0).default_color = colors[cabletype]
    return true


func _process(delta):
    if flowing:
        var lines = $Lines.get_children()
        for i in len(lines):
            var fill = lines[i].get_child(0)
            if i == input:
                fill.set_point_position(0, Vector2(size,0))
                fill.set_point_position(1, Vector2(size-min(flow,1)*size,0))
            else:
                fill.set_point_position(0, Vector2(0,0))
                fill.set_point_position(1, Vector2(max(flow-1,0)*size,0))
        if flow == 2:
            flowing = false
            var outputs = dir.duplicate()
            outputs[input] = 0
            emit_signal("output_flow", coords, outputs, cabletype)
                    
                    



func _on_Clickker_mouse_entered():
    $Clickker.color.a = 0.5


func _on_Clickker_mouse_exited():
    $Clickker.color.a = 0


func _on_Clickker_gui_input(event):
    if flow == 0:
        if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT and event.pressed:
                rotate_pipe(true)
            if event.button_index == BUTTON_RIGHT and event.pressed:
                rotate_pipe(false)

func rotate_pipe(clockwise):
    if clockwise:
        dir.push_front(dir.pop_back())
    else:
        dir.push_back(dir.pop_front())
    set_lines()


func kill_out(i):
    $Lines.get_child(i).get_child(0).z_index = 1
    $Lines.get_child(i).get_child(0).default_color.v -= 0.4
    
    
