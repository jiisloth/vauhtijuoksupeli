extends Node2D


export(PackedScene) var Pipe
export(int) var PipeSize = 64
export(float) var FlowSpeed = 0.2


var pipes = {}
const outdirs = [Vector2(0,-1),Vector2(-1,0),Vector2(0,1),Vector2(1,0)]


func _ready():
    set_random_pipes()
    
    
func set_random_pipes():
    $PipeHolder.position = Vector2.ONE * PipeSize/2
    for x in 10:
        for y in 8:
            var pipe = Pipe.instance()
            var dir = [1,1,max(randi()%6-4,0),max(randi()%10-8,0)]
            dir.shuffle()
            if Vector2(x,y) in [Vector2(0,0),Vector2(0,7),Vector2(9,0),Vector2(9,7)]:
                dir = [1,1,1,1]
            pipe.dir = dir
            pipe.position = Vector2(x * PipeSize, y * PipeSize)
            pipe.coords = Vector2(x,y)
            pipes[Vector2(x,y)] = pipe
            pipe.connect("output_flow", self, "pipe_out_flow")
            $PipeHolder.add_child(pipe)


func _on_Timer_timeout():
    pipes[Vector2(0,0)].start_flow(0, 0, FlowSpeed)
    pipes[Vector2(0,7)].start_flow(1, 1, FlowSpeed*0.5)
    pipes[Vector2(9,0)].start_flow(3, 2, FlowSpeed*0.3)
    pipes[Vector2(9,7)].start_flow(2, 3, FlowSpeed*0.2)
        
            
func pipe_out_flow(coords, output, outtype):
    for i in len(output):
        if output[i]:
            if coords + outdirs[i] in pipes.keys():
                if not pipes[coords + outdirs[i]].start_flow((i+2)%4, outtype, FlowSpeed):
                    pipes[coords].kill_out(i)
            else:
                pipes[coords].kill_out(i)
                
                    
