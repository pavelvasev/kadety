Item {

  signal clicked( object index );

  
  property var curstage

  Repeater {
    model: Object.keys( curstage.start_ai ).length

    Spheres {
      property var actor_name: Object.keys( curstage.start_ai )[ index ]
      property var actor: curstage.ai[ actor_name ]

      positions: [0,0,0]
      center: [ actor.pos[0] *5, 0, actor.pos[1]* (-5) ]
      color: actor.color
      radius: 1

      Spheres {
        radius: 0.2
        color: [0,0,1]
        positions: [0,0,0]
        center: {
          var alfa = parent.actor.angle;
          var ttt = parent.center.slice(0);
          var r = parent.radius;
          ttt[0] = ttt[0] + Math.cos( alfa * Math.PI / 180 ) * r;
          ttt[2] = ttt[2] - Math.sin( alfa * Math.PI / 180 ) * r;
          return ttt;
        }
      }
    } // sp
  } // rep
}