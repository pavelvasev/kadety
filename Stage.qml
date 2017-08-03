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


  property var total: kstartpos.length

  property var kstartpos: []
  property var kcolors: []
  property var kstartpovorot: []

  ////////////////////////////////

  function process() {
    var res = [];
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
        var q = program[i].start + getprogramlen(i);
        if (q > t) t = q;
      }
      return t;
    }


  function getprogramlen(i) {
    var rec = program[i];
    return rec.time || ( rec.type == "shag" ? Math.ceil( rec.value ) : 1);;
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
    var isInt = /^\+?\d+$/.test( tgt );
    if (isInt) return [ parseInt(tgt) ];

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
    var respos = arrayClone( kstartpos );
    var respovorot = arrayClone( kstartpovorot );
         
    var tt = time;
    for (var q=0; q<prg.length; q++) {
        var rec = prg[q];
        if (rec.start > tt) continue;

        var kadets = getkadetsfromtarget( rec.target );
        var rectime = getprogramlen( q );
        var lefttime = rec.start + rectime < tt ? rectime : tt - rec.start;

        //console.log(rec, lefttime, rectime );
        
        if (rec.type == "shag") {          
          for (var k=0; k<kadets.length; k++) {
            var kadet = kadets[k] -1;
            //console.log( "shag kadeta provort=",respovorot[kadet] );
            var newx = respos[kadet][0] + rec.value * Math.cos( respovorot[kadet] * Math.PI / 180 ) * lefttime / rectime;
            var newy = respos[kadet][1] + rec.value * Math.sin( respovorot[kadet] * Math.PI / 180 ) * lefttime / rectime;
            respos[kadet][0] = newx;
            respos[kadet][1] = newy;
          }
        }
        if (rec.type == "povorot") {          
          for (var k=0; k<kadets.length; k++) {
            var kadet = kadets[k] -1;
            //console.log("povorot kadeta na",rec.value ); // * lefttime / rectime);
            if (rec.value == 1001) {              
              respovorot[kadet] = respovorot[kadet] + (270- respovorot[kadet])* lefttime / rectime;
              //console.log( "respovorot[kadet]===",respovorot[kadet]);
            }
            else
              respovorot[kadet] = respovorot[kadet] + rec.value * lefttime / rectime;
          }
        }
    }

    return [respos, respovorot];
  }

  property var kpos: []
  property var kpovorot: []

  property var keval: {
    var r = evalpos( stage.time );
    kpos = r[0];
    kpovorot = r[1];
  }

  property var finkpos: []
  property var finkpovorot: []

  property var finkeval: {
    var r = evalpos( stage.timelen );
    finkpos = r[0];
    finkpovorot = r[1];
  }


  /////////////////////////////////

function arrayClone( arr ) {

    var i, copy;

    if( Array.isArray( arr ) ) {
        copy = arr.slice( 0 );
        for( i = 0; i < copy.length; i++ ) {
            copy[ i ] = arrayClone( copy[ i ] );
        }
        return copy;
    } else if( typeof arr === 'object' ) {
        throw 'Cannot clone array containing an object!';
    } else {
        return arr;
    }

}

}