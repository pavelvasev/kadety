Item {

  signal clicked( object index );

  JsonLoader {
    file: Qt.resolvedUrl( "Officer2.json" )
    id: json
  }
  
  property var curstage

  Repeater {
    model: Object.keys( curstage.start_ai ).length

    Trimesh {
      property var actor_name: Object.keys( curstage.start_ai )[ index ]
      property var actor: curstage.ai[ actor_name ]

      positions: [0,0,0]
      center: [ actor.pos[0] *5, 0, actor.pos[1]* (-5) ]
      color: actor.color

      scale: 3
      
      positions: json.output ? json.output.vertices[0].values : []
      indices: json.output ? json.output.connectivity[0].indices : []

      rotate: [ 0, (90+actor.angle) * Math.PI / 180,0]
    }

  } // rep
}