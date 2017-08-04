Lines {
  id: ll
  color: [0.5, 0.5, 0.5]

  property var nx: 10
  property var ny: 10
  property var sx: 1
  property var sy: 1
  property var r:5

  positions: compute()

  function compute() {
    var res = [];

    for (var xx = 0; xx<nx; xx++)
    {
      res = res.concat( [xx+sx,0, sy] );
      res = res.concat( [xx+sx,0, sy+ny-1] );
    }

    for (var yy = 0; yy<ny; yy++)
    {
      res = res.concat( [sx,0, yy+sy] );
      res = res.concat( [sx+nx-1,0, yy+sy] );
    }

    for (var i=0; i<res.length; i+=3) {
      res[i] *= r;
      res[i+2] *= -r;
    }

    console.log(res);
    return res;

  }
}