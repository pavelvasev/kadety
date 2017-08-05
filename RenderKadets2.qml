CreativePoints {

  SceneMouseEvents {
    onDoubleClicked: {
      var r = sp.intersect( sceneMouse, sp.radius/2 );
      //console.log( r );
      if (r)
        sp.clicked( r.index );
    }
  }
  signal clicked( int index );

  radius: 7

  property var curstage

  function f( nomer )
  {
    var kp = curstage.kpos[nomer];
    if (!kp) return [0,0,0];
    var r = 5;
    return [ r*kp[0], 0, -r*kp[1] ];
  }

  function process() {
    var res = [];
    for (var i=0; i<total; i++) {
      var p = f( i );
      res = res.concat( p );
    }
    return res;
  }


    positions: process( )
    //radius_p: 1
    //radius: 1
    colors: [].concat.apply([], curstage.kcolors);
    id: sp

    CreativePoints {
      radius: 2
      color: [0,0,1]

      positions: {
        var pp = parent.positions;
        var res = [];
        var r = parent.radius/8;

        for (var i=0; i<pp.length; i+=3) {

          var ttt = [pp[i], pp[i+1], pp[i+2]];
          var alfa = curstage.ai [ i/3 ];
          ttt[0] = ttt[0] + Math.cos( alfa * Math.PI / 180 ) * r;
          ttt[2] = ttt[2] - Math.sin( alfa * Math.PI / 180 ) * r;
          res = res.concat(ttt);
        }

        return res;        
      }
    }



}
