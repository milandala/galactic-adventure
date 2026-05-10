using {galactic as db} from '../db/schema';


service CosmicService @(requires: 'authenticated-user') {

  @restrict       : [{
    grant: [
      'CREATE',
      'READ',
      'UPDATE',
      'DELETE'
    ],
    where: 'originPlanet.code = $user.planetCode'
  }]
  @cds.query.limit: {
    default: 10,
    max    : 20
  }
  @odata.draft.enabled
  entity Spacefarers     as projection on db.Spacefarers;

  @restrict: [{
    grant: 'READ',
    to   : 'authenticated-user'
  }]
  entity Departments     as projection on db.Departments;

  @restrict: [{
    grant: 'READ',
    to   : 'authenticated-user'
  }]
  entity Positions       as projection on db.Positions;

  @restrict: [{
    grant: 'READ',
    to   : 'authenticated-user'
  }]
  entity Planets         as projection on db.Planets;

  @restrict: [{
    grant: 'READ',
    to   : 'authenticated-user'
  }]
  entity SpacesuitColors as projection on db.SpacesuitColors;
}
