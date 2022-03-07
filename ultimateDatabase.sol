// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract UltimateDatabase {

  struct EntityStruct {
    uint entityData;
    uint id; 
  }

  mapping(address => EntityStruct) public entityStructs;
  address[] public entityList;

  function isEntity(address _entityAddress) public view returns(bool isIndeed) {
    if(entityList.length == 0) return false;
    return (entityList[entityStructs[_entityAddress].id] == _entityAddress);
  }

  function getEntityCount() public view returns(uint entityCount) {
    return entityList.length;
  }

  function newEntity(address _entityAddress, uint _data) public returns(bool success) {
    require(isEntity(_entityAddress) == false, "entity with this address already exists");
    entityStructs[_entityAddress].entityData = _data;
    entityList.push(_entityAddress);
    entityStructs[_entityAddress].id = entityList.length - 1;
    return true;
  }

  function update(address _entityAddress, uint _data) public returns (bool success) {
    require(isEntity(_entityAddress) == true, "entity to update does not exist");
    entityStructs[_entityAddress].entityData = _data;
    return true;
  }

  function deleteEntity(address _entityAddress) public returns (bool success) {
    require(isEntity(_entityAddress) == true, "entity to delete does not exist"); // check item exists
    uint _idToRemove = entityStructs[_entityAddress].id; // find the id of item to be removed
    address _lastItem = entityList[entityList.length - 1]; // save last item in array
    entityList[_idToRemove] = _lastItem; // replace item to be removed with last item in array
    entityStructs[_lastItem].id = _idToRemove; // update last item's id in the struct
    entityList.pop(); // remove last item from array
    delete entityStructs[_lastItem]; // reset struct
    return true; // return success
  }
}
