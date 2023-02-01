{
  "activo": true,
  $and: [{
    "edad": {
      $gte: 25
    }
  }, {
    "edad": {
      $lte: 30
    }
  }, {
    "fechaAlta": {
      $gte: ISODate('2008-01-01T00:00:00Z')
    }
  }, {
    "fechaAlta": {
      $lte: ISODate('2010-01-01T00:00:00Z')
    }
  }],
  "ciudad": {
    $ne: 'Barcelona'
  },
  "cursos.nombre": 'mongodb'
}
