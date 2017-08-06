Item {
  id: stage

  property var title: "Этап"

    property var groups: { return {
      "g1" : [1,2,3,4, 10, 11, 12, 13,  19,20,21,22,  28, 29, 30, 31],
      "g2" : [11,12,13,14,15,16]
    }
    }

    property var program:  [
      { type: "shag", start: 3, target: "g1", value: 5 },
      { type: "povorot", start: 8, target: "g1", value: -90 },
      { type: "shag", start: 10, target: "g1", value: 5 }
    ]

  
  property var start_ai

  property var final_ai: evalpos( stage.timelen );
  property var ai: evalpos( stage.time );

  

  ////////////////////////////////

  function process() {
    var res = [];
//    var total = 
    for (var i=0; i<total; i++) {
      var p = f( i );
      res = res.concat( p );
    }
    return res;
  }

  property var start: 0

  property var time: 0
  property var timelen: {
      var t = 0;
      for (var i=0; i<program.length; i++) {
        var q = program[i].start + program[i].time;
        if (q > t) t = q;
      }
      return t;
    }

///////////////////
  function findkadetgroups( kdt ) {
    kdt = kdt.toString();
    var res = [];
    for (var i in stage.groups)
      if (stage.groups[i].indexOf(kdt) >= 0) res.push(i);
    return res;
  }

  // выдать список актеров по цели
  // цель = запись[,запись]
  // запись = число|имягруппы
  function getkadetsfromtarget( tgt ) {
    if (start_ai[ tgt ]) return [tgt];
    //var isInt = /^\+?\d+$/.test( tgt );
    //if (isInt) return [ parseInt(tgt) ];

    if (stage.groups[tgt]) return flatten( getkadetsfromtarget( stage.groups[tgt] ) );

    var sp = Array.isArray(tgt) ? tgt : tgt.split(/[ ,]+/);

    var kr = sp.indexOf("кроме");
    if (kr > 0) {
      var ok = getkadetsfromtarget( sp.slice( 0,kr ) );
      var krome = getkadetsfromtarget( sp.slice( kr ) );
      return ok.filter(function(i) {return krome.indexOf(i) < 0;});
    }

    // если не содержит запятых, и не целое число -- значит должна быть запись о группе
    if (sp.length > 1) {
      var res = sp.map( function(v) { return getkadetsfromtarget(v); } );
      return flatten( res );
    }

    return [];
  }

  function flatten(arr) {
  return arr.reduce(function (flat, toFlatten) {
    return flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten);
  }, []);
  }

  
  function evalpos( time ) {
    var prg = stage.program;
    var rai = JSON.parse(JSON.stringify( start_ai ));
         
    var tt = time;

    for (var q=0; q<prg.length; q++) {
        var rec = prg[q];
        if (rec.start > tt) {
//          console.log("SKIP rec",rec,tt);
          continue;
        }
        // console.log("PASS rec",rec,tt);

        var kadets = getkadetsfromtarget( rec.target );
        var lefttime = rec.start + rec.time < tt ? rec.time : tt - rec.start;
        
        if (rec.type == "shag") {
          for (var k=0; k<kadets.length; k++) {
            var kadet_name = kadets[k];
            var kadet = rai[ kadet_name ];
            
            var newx = kadet.pos[0] + rec.value * Math.cos( kadet.angle * Math.PI / 180 ) * lefttime / rec.time;
            var newy = kadet.pos[1] + rec.value * Math.sin( kadet.angle * Math.PI / 180 ) * lefttime / rec.time;

            kadet.pos = [newx, newy];
          }
        }
        else if (rec.type == "povorot") {          
          for (var k=0; k<kadets.length; k++) {
            var kadet_name = kadets[k];
            var kadet = rai[ kadet_name ];
            if (!kadet) debugger;

            if (rec.value == 1001) {
              kadet.angle = kadet.angle + (270 - kadet.angle) * lefttime / rec.time;
            }
            else
              kadet.angle = kadet.angle + rec.value * lefttime / rec.time; 
          }
        }
        else if (rec.type == "rovno") {          
          for (var k=0; k<kadets.length; k++) {
            var kadet_name = kadets[k];
            var kadet = rai[ kadet_name ];
            kadet.pos[0] = Math.round( kadet.pos[0]*2 )/2;
            kadet.pos[1] = Math.round( kadet.pos[1]*2 )/2;
            kadet.angle = Math.round( kadet.angle / 15) * 15;
          }
        }
        else if (rec.type == "color") {
          //console.log("setting color to kadets=",kadets);
          for (var k=0; k<kadets.length; k++) {
            var kadet_name = kadets[k];
            var kadet = rai[ kadet_name ];
            kadet.color = parsecolor( rec.value );
          }
        }
    }

    // console.log("evalpos rai=",rai );
    return rai;
  }

  function parsecolor( col ) {
    var s = col.split(/[,]/);
    if (s.length >= 3)
      return [ parseFloat( s[0] ), parseFloat( s[1] ), parseFloat( s[2] ) ];
    return [1,0,0];
  }

}