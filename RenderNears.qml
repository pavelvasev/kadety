Item {
  id: item

  CheckBoxParam {
    text: "Выявлять конфликты"
    id: dowork
    tag: "right"
  }

  property var curstage

  function actorxyz( actor ) {
    return [actor.pos[0] *5, 3, actor.pos[1]* (-5)]
  }

  function find_conflicts( ai ) {
    if (!dowork.checked) return  { pos: [], text: [] }

    var res = [];
    var keys = Object.keys(ai);
    var len = keys.length;
    var txt = [];
    for (var i=0; i<len; i++) {
      var k1 = keys[i];
      var actor1 = ai[k1];

      for (var j=i+1; j<len; j++ ) {
        var k2 = keys[j];
        var actor2 = ai[k2];
        //if (actor1 === actor2) continue;
        var dist = ( actor1.pos[0] - actor2.pos[0] )*( actor1.pos[0] - actor2.pos[0] ) + ( actor1.pos[1] - actor2.pos[1] )*( actor1.pos[1] - actor2.pos[1] );
        if (dist < 0.005) {
          res = res.concat( actorxyz( actor1 ) );
          txt.push( k1 + "," + k2 );
        }
        //  if (dist < 0.005) res.push( { xyz: actorxyz( actor1 ), title: k1 + "," + k2 } );
      }
    }
    return { pos: res, text: txt };
  }

  Text {
    property var tag: "right"
    text: c.text.join("\n")
    Rectangle {
      color: "red"
      anchors.fill: parent
      z: -1
    }
  }

  property var c: find_conflicts( curstage.ai )
  
  Spheres {
    color: [1,0,0]
    nx: 5
    ny: 7
//    opacity: 0.5
    positions: c.pos
    radius: 5 
    wire: true
  }
  
}