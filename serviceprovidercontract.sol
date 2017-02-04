contract mortal{

  address public owner;

  function mortal(){

    owner = msg.sender;

  }

  modifier onlyOwner{
    if (msg.sender != owner){
      throw;
    }else{
      _;
    }
  }

  function kill() onlyOwner{

    suicide(owner);

  }
}

contract User is mortal{
  
  string public userName;

  mapping(address=>Service) public services;

  struct Service{
    bool active;
    uint lastUpdate;
    uint256 debt;
  }

  function User(string _name) {
    userName = _name;
  }

  function registerToProvider(address _providerAddress) onlyOwner {
    services[_providerAddress] = Service({
        active: true,
        lastUpdate: now,
        debt: 0
      });
  }



  function setDebt(uint256 _debt){
    if(services[msg.sender].active){
      services[msg.sender].lastUpdate = now;
      services[msg.sender].debt       = _debt;
      }else{
        throw;
      }
   } 

  function payToProvider(address _providerAddress) onlyOwner {
     if (!_providerAddress.send(services[_providerAddress].debt)) throw;
   } 

  function unsubscribe(address _providerAddress) onlyOwner {
      if(services[_providerAddress].debt == 0){
        services[_providerAddress].active = false;
      }else{
        throw;
      }
   }

}

contract Provider is mortal{

  string public providerName;
  string public description;

  function Provider(
    string _name, 
    string _descrption){

    providerName = _name;
    description = _descrption;

  }

  function setDebt(uint _debt, address _userAddress){

    User person = User(_userAddress);
    person.setDebt(_debt);

  }

}

