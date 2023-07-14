extends Control


export(PackedScene) var Mainosmyynti
export(PackedScene) var Tekniikka
export(PackedScene) var MediaMarkkinointi
export(PackedScene) var Huolto
export(PackedScene) var Sisalto
export(PackedScene) var TilaDeco
export(PackedScene) var EndGame

var current_scene = null

func start_scene(ps):
    var scene = ps.instance()
    $Menu.hide()
    current_scene = scene
    add_child(scene)
    
func _process(delta):
    if Input.is_action_just_pressed("QuitGame"):
        if current_scene:
            current_scene.queue_free()
            $Menu.show()
        

func _on_Mainosmyynti_pressed():
    start_scene(Mainosmyynti)


func _on_Tekniikka_pressed():
    start_scene(Tekniikka)


func _on_MediaMarkkinointi_pressed():
    start_scene(MediaMarkkinointi)


func _on_Huolto_pressed():
    start_scene(Huolto)


func _on_Sisalto_pressed():
    start_scene(Sisalto)


func _on_TilaDeco_pressed():
    start_scene(TilaDeco)


func _on_Endgame_pressed():
    start_scene(EndGame)
